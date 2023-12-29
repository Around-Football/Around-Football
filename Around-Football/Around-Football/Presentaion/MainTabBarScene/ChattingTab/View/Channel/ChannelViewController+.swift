//
//  ChannelViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 11/13/23.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import MessageKit

extension ChannelViewController {
    func bindContentView() {
        viewModel.currentUser
            .map { $0 != nil }
            .bind(to: loginLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.currentUser
            .map { $0 == nil }
            .bind(to: channelTableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func bindChannels() {
        Observable.combineLatest(viewModel.channels, segmentControlView.rx.selectedSegmentIndex.asObservable())
            .withUnretained(self)
            .map({ (owner, observe) in
                let channels = observe.0
                let index = observe.1
                if index == 0, let currentUser = try? owner.viewModel.currentUser.value() {
                    return channels.filter { $0.recruitUserID == currentUser.id }
                } else if let currentUser = try? owner.viewModel.currentUser.value() {
                   return channels.filter { $0.recruitUserID != currentUser.id}
                }
                return []
            })
            .map { [ChannelSectionModel(model: "", items: $0)] }
            .bind(to: channelTableView.rx.items(dataSource: channelTableViewDataSource))
            .disposed(by: disposeBag)
        
        channelTableView.rx.itemDeleted
            .withUnretained(self)
            .flatMap({ (owner, indexPath) -> Observable<IndexPath> in
                return owner.presentAlertController(indexPath: indexPath)
            })
            .subscribe(with: self) { owner, indexPath in
                owner.invokedDeleteChannel.onNext(indexPath)
                print("DEBUG - remove row: \(owner.viewModel.channels.value[indexPath.row])")
            }
            .disposed(by: disposeBag)
    }
    
    func bindLoginModalView(with outputObservable: Observable<Bool>) {
        outputObservable
            .withUnretained(self)
            .subscribe(onNext: { (owner, isShowing) in
                if isShowing {
                    owner.viewModel.showLoginView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindNavigateChannelView(with outputObservable: Observable<ChannelInfo>) {
        outputObservable
            .withUnretained(self)
            .subscribe { (owner, channelInfo) in
                owner.viewModel.showChatView(channelInfo: channelInfo)
            }
            .disposed(by: disposeBag)
    }
    
    func bindTapSegmentControl() {
        segmentControlView.rx.selectedSegmentIndex
            .bind { [weak self] index in
                guard let self = self else { return }
                guard segmentControlView.frame.width != 0 else { return }
                let segmentWidth = segmentControlView.frame.width / CGFloat(segmentControlView.numberOfSegments)
                let selectedSegmentCenterX = segmentWidth * CGFloat(index) + segmentWidth / 2
                let underlineViewWidth = underLineView.frame.width

                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.underLineView.frame.origin.x = selectedSegmentCenterX - underlineViewWidth / 2
                        self.view.layoutIfNeeded()
                    })
                }
            }
            .disposed(by: disposeBag)
    }
    
    func presentAlertController(indexPath: IndexPath) -> Observable<IndexPath> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create { } }
            let alertController = UIAlertController(title: .deleteChannel,
                                                    message: .deleteChannel,
                                                    preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "나가기", style: .destructive) { _ in
                observer.onNext(indexPath)
                observer.onCompleted()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                observer.onCompleted()
            }
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            self.viewModel.showDeleteAlertView(alert: alertController)
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
    }
}

extension ChannelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

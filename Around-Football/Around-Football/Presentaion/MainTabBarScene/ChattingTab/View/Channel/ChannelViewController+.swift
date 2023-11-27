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
        viewModel.channels
            .map { [ChannelSectionModel(model: "", items: $0)] }
            .bind(to: channelTableView.rx.items(dataSource: channelTableViewDataSource))
            .disposed(by: disposeBag)
        
        channelTableView.rx.itemDeleted
            .subscribe(with: self, onNext: { owner, indexPath in
                // TODO: - Remove Channel from firestore
                print("remove row: \(owner.viewModel.channels.value[indexPath.row])")
            })
            .disposed(by: disposeBag)
    }
    
    func bindLoginModalView(with outputObservable: Observable<Bool>) {
        outputObservable
            .withUnretained(self)
            .subscribe(onNext: { (owner, isShowing) in
                if isShowing {
                    print("currentUser nil")
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
    
    func hideChatAlarmNumber(cell: ChannelTableViewCell) {
        cell.chatAlarmNumberLabel.text = ""
        cell.chatAlarmNumberLabel.isHidden = true
    }
    
    func showChatAlarmNumber(cell: ChannelTableViewCell, alarmNumber: Int) {
        var alarmString = ""
        alarmNumber > 999 ? (alarmString = "999+") : (alarmString = "\(alarmNumber)")
        cell.chatAlarmNumberLabel.text = alarmString
        cell.chatAlarmNumberLabel.isHidden = false
        cell.updateAlarmLabelUI()
    }
    
    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "a h:mm"
        } else if calendar.isDateInYesterday(date) {
            return "어제"
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            formatter.dateFormat = "M월 d일"
        } else {
            formatter.dateFormat = "yyyy년 M월 d일"
        }
        return formatter.string(from: date)
    }
    
}

extension ChannelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

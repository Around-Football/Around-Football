//
//  WrittenPostViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/10/23.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import Then

final class WrittenPostViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Properties
    
    var viewModel: InfoPostViewModel
    private let loadWrittenPost: PublishSubject<Void> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    private lazy var emptyView = EmptyAFView(type: EmptyAFView.SettingTitle.written).then {
        $0.isHidden = true
    }

    private var writtenPostTableView = UITableView().then {
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
    }
    
    private let segmentContainerView = UIView().then {
        $0.backgroundColor = .systemBackground
    }
 
    lazy var segmentControlView = UISegmentedControl().then {
        $0.selectedSegmentTintColor = .clear
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        $0.insertSegment(withTitle: "모집 공고", at: 0, animated: true)
        $0.insertSegment(withTitle: "마감 공고", at: 1, animated: true)
        $0.setWidth(calculateSegmentWidth(title: "모집 공고"), forSegmentAt: 0)
        $0.setWidth(calculateSegmentWidth(title: "마감 공고"), forSegmentAt: 1)

        $0.selectedSegmentIndex = 0
        
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: AFColor.grayScale100,
            NSAttributedString.Key.font: AFFont.titleRegular as Any
        ], for: .normal)

        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: AFColor.secondary,
            NSAttributedString.Key.font: AFFont.titleRegular as Any], for: .selected)
    }
    
    let underLineView = UIView().then {
        $0.backgroundColor = AFColor.secondary
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: InfoPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
        loadWrittenPost.onNext(())
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadWrittenPost.onNext(())
//    }
    
    // MARK: - Helpers
    
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
    
    private func bind() {
        let input = InfoPostViewModel.Input(loadPost: loadWrittenPost.asObservable(),
                                            selectedSegment: segmentControlView.rx.selectedSegmentIndex.asObservable())
        
        let output = viewModel.transform(input)
        bindRecruit(with: output.writtenList)
        bindNavigateDetailView(with: output.writtenList)
        bindTapSegmentControl()
    }
    
    private func bindNavigateDetailView(with outputObservable: Observable<[Recruit]>) {
        writtenPostTableView.rx.itemSelected
            .withLatestFrom(outputObservable) { [weak self] (indexPath, recruits) -> Recruit in
                self?.writtenPostTableView.deselectRow(at: indexPath, animated: true)
                return recruits[indexPath.row]
            }
            .withUnretained(self)
            .subscribe { (owner, recruit) in
                owner.viewModel.showDetailView(recruit: recruit)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindRecruit(with outputObservable: Observable<[Recruit]>) {
        outputObservable
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] recruits in
                guard let self else { return }
                emptyView.isHidden = recruits.isEmpty ? false : true
            })
            .bind(to: writtenPostTableView.rx.items(cellIdentifier: HomeTableViewCell.id,
                                             cellType: HomeTableViewCell.self)) { index, item, cell in
                cell.bindContents(item: item)
                cell.configureButtonTap()
            }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
        title = "작성 글"
        view.backgroundColor = .white
        
        view.addSubviews(writtenPostTableView,
                         segmentContainerView,
                         emptyView)
        
        segmentContainerView.addSubviews(segmentControlView,
                                       underLineView)
        
        segmentContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        segmentControlView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        let firstSegmentWidth = calculateSegmentWidth(title: "모집 공고")
        let firstSegmentCenterX = firstSegmentWidth / 2
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(segmentControlView.snp.bottom)
            $0.height.equalTo(5)
            $0.width.equalTo(firstSegmentWidth - 20)
            $0.centerX.equalTo(segmentControlView.snp.leading).offset(firstSegmentCenterX)
        }
        
        writtenPostTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentContainerView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(segmentContainerView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}

private func calculateSegmentWidth(title: String) -> CGFloat {
    let attributes = [NSAttributedString.Key.font: AFFont.titleRegular]
    let size = (title as NSString).size(withAttributes: attributes as [NSAttributedString.Key : Any])
    return size.width + 20
}

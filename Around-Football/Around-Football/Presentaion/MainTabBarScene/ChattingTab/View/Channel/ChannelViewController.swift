//
//  ChannelViewController.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import UIKit

import FirebaseAuth
import SnapKit
import Then
import RxSwift
import RxDataSources

final class ChannelViewController: UIViewController {
        
    // MARK: - Properties
    typealias ChannelSectionModel = SectionModel<String, ChannelInfo>
    
    let viewModel: ChannelViewModel
    let disposeBag = DisposeBag()
    
    private let invokedViewWillAppear = PublishSubject<Void>()
    let invokedDeleteChannel = PublishSubject<IndexPath>()
    
    private let titleLabel = UILabel().then {
        $0.text = "채팅"
        $0.font = AFFont.titleMedium
        $0.textColor = AFColor.secondary
    }
    
    private let segmentContainerView = UIView().then {
        $0.backgroundColor = .systemBackground
    }
 
    lazy var segmentControlView = UISegmentedControl().then {
        $0.selectedSegmentTintColor = .clear
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        $0.insertSegment(withTitle: "용병 신청", at: 0, animated: true)
        $0.insertSegment(withTitle: "용병 모집", at: 0, animated: true)
        $0.setWidth(calculateSegmentWidth(title: "용병 신청"), forSegmentAt: 0)
        $0.setWidth(calculateSegmentWidth(title: "용병 모집"), forSegmentAt: 1)

        $0.selectedSegmentIndex = 0
        
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: AFColor.grayScale100,
            NSAttributedString.Key.font: AFFont.titleRegular as Any
        ], for: .normal)

        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: AFColor.secondary,
            NSAttributedString.Key.font: AFFont.titleRegular as Any], for: .selected)
    }
        
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = AFColor.secondary
        return view
    }()
    
    // 움직일 underLineView의 leadingAnchor 따로 작성
    private var leadingConstraint: Constraint?

    let channelTableView = UITableView().then {
        $0.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.cellId)
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
    }
    
    let deleteChannelAlert = UIAlertController(title: .deleteChannel, message: .deleteChannel, preferredStyle: .alert)
    
    var ownChannelDataSource: RxTableViewSectionedReloadDataSource<ChannelSectionModel>!
    
    var recruitedChannelDataSource: RxTableViewSectionedReloadDataSource<ChannelSectionModel>!
    
    let loginLabel = UILabel().then {
        $0.backgroundColor = .systemBackground
        $0.text = """
        로그인이 필요한 서비스입니다.
        로그인을 해주세요.
        """
        $0.font = AFFont.text
        $0.textColor = AFColor.secondary
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: ChannelViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG - Deinit (channelViewController)")
        viewModel.removeListner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configure()
        channelTableView.rowHeight = UITableView.automaticDimension
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false

        invokedViewWillAppear.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - Helpers
    
    func configure() {
        channelTableView.delegate = self
        ownChannelDataSource = RxTableViewSectionedReloadDataSource(configureCell: { data, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.cellId, for: indexPath) as! ChannelTableViewCell
                cell.configure(channelInfo: item)
//            cell.userNameLabel.text = item.withUserName
//            cell.chatPreviewLabel.text = item.previewContent
//            let alarmNumber = item.alarmNumber
//            alarmNumber == 0 ? self.hideChatAlarmNumber(cell: cell) : self.showChatAlarmNumber(cell: cell, alarmNumber: alarmNumber)
//            let date = item.recentDate
//            cell.recentDateLabel.text = self.formatDate(date)
            
            return cell

        })
        
        recruitedChannelDataSource = RxTableViewSectionedReloadDataSource(configureCell: { data, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.cellId, for: indexPath) as! ChannelTableViewCell
            cell.configure(channelInfo: item)
            return cell
        })
        
        ownChannelDataSource?.canMoveRowAtIndexPath = { _, _ in return false }
        ownChannelDataSource?.canEditRowAtIndexPath = { dataSource, index in return true }
        
        recruitedChannelDataSource?.canMoveRowAtIndexPath = { _, _ in return false }
        recruitedChannelDataSource?.canEditRowAtIndexPath = { dataSource, index in return true }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubviews(
            titleLabel,
            segmentContainerView,
            channelTableView,
            loginLabel
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
        }
        
        segmentContainerView.addSubviews(segmentControlView,
                                       underLineView)
        
        segmentContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        segmentControlView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        let firstSegmentWidth = calculateSegmentWidth(title: "용병 신청")
        let firstSegmentCenterX = firstSegmentWidth / 2

        underLineView.snp.makeConstraints {
            $0.top.equalTo(segmentControlView.snp.bottom)
            $0.height.equalTo(5)
            $0.width.equalTo(firstSegmentWidth - 20)
            $0.centerX.equalTo(segmentControlView.snp.leading).offset(firstSegmentCenterX)            
        }
        
        channelTableView.snp.makeConstraints {
            $0.top.equalTo(segmentContainerView.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        loginLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func bind() {
        let input = ChannelViewModel.Input(
            invokedViewWillAppear: invokedViewWillAppear,
            selectedChannel: channelTableView.rx.itemSelected.asObservable(),
            invokedDeleteChannel: invokedDeleteChannel
        )
        
        let output = viewModel.transform(input)
        
        bindContentView()
        bindChannels()
        bindLoginModalView(with: output.isShowing)
        bindNavigateChannelView(with: output.navigateTo)
        bindTapSegmentControl()
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
    
    private func calculateSegmentWidth(title: String) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: AFFont.titleRegular]
        let size = (title as NSString).size(withAttributes: attributes as [NSAttributedString.Key : Any])
        return size.width + 20
    }
}

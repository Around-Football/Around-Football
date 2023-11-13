//
//  ChannelViewController.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import UIKit

import SnapKit
import Then
import RxSwift

protocol ChannelViewControllerDelegate: AnyObject {
    func presentLoginViewController()
    func pushChatView()
}

final class ChannelViewController: UIViewController {

    // MARK: - Properties
    
//    weak var delegate: ChannelViewControllerDelegate?
    let viewModel: ChannelViewModel
    let disposeBag = DisposeBag()
    
    private let invokedViewDidLoad = PublishSubject<Void>()
    
    lazy var channelTableView = UITableView().then {
        $0.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.cellId)
        $0.delegate = self
    }
    
    // MARK: - Lifecycles
    
    init(delegate: ChannelViewControllerDelegate? = nil, viewModel: ChannelViewModel) {
//        self.delegate = delegate
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        title = "채팅"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        invokedViewDidLoad.onNext(())
        viewModel.setupListener()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(channelTableView)
        channelTableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func bind() {
        let input = ChannelViewModel.Input(invokedViewDidLoad: invokedViewDidLoad.asObservable())
        
        viewModel.transform(input)
    }
    
}

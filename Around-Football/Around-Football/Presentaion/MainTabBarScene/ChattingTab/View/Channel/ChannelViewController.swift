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

final class ChannelViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: ChannelViewModel
    let disposeBag = DisposeBag()
    
    private let invokedViewWillAppear = PublishSubject<Void>()
    
    lazy var channelTableView = UITableView().then {
        $0.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.cellId)
        $0.delegate = self
    }
    
    let loginLabel = UILabel().then {
        $0.text = """
        로그인이 필요한 서비스입니다.
        로그인을 해주세요.
        """
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: ChannelViewModel) {
        print("init")
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        navigationController?.navigationBar.backgroundColor = .systemBackground
        title = "채팅"

        
        print("\(Auth.auth().currentUser?.uid)")
        
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
        bind()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        invokedViewWillAppear.onNext(())
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubviews(
            channelTableView,
            loginLabel
        )
        channelTableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        loginLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func bind() {
        let input = ChannelViewModel.Input(invokedViewWillAppear: invokedViewWillAppear)
        
        let output = viewModel.transform(input)
        
        bindContentView()
        bindChannels()
        bindLoginModalView(with: output.isShowing)
    }
}

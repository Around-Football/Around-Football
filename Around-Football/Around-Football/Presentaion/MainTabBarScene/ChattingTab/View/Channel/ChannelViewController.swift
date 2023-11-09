//
//  ChannelViewController.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import UIKit

import SnapKit
import Then

protocol ChannelViewControllerDelegate: AnyObject {
    func presentLoginViewController()
    func pushChatView()
}

final class ChannelViewController: UIViewController {

    // MARK: - Properties
    
    weak var delegate: ChannelViewControllerDelegate?
    let viewModel: ChannelViewModel
    
    lazy var channelTableView = UITableView().then {
        $0.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.cellId)
    }
    
    // MARK: - Lifecycles
    
    init(delegate: ChannelViewControllerDelegate? = nil, viewModel: ChannelViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
    }
    
}

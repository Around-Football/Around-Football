//
//  ChatViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol ChatViewControllerDelegate: AnyObject {
    //
}

final class ChatViewController: UIViewController {
    
    weak var delegate: ChatViewControllerDelegate?
    private var viewModel: ChatViewModel?
    
    init(delegate: ChatViewControllerDelegate, viewModel: ChatViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .green
    }
    
}

//
//  ChannelViewController.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import UIKit

protocol ChannelViewControllerDelegate: AnyObject {
    func presentLoginViewController()
    func pushChatView()
}

final class ChannelViewController: UIViewController {

    weak var delegate: ChannelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

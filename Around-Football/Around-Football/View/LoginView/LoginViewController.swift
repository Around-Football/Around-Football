//
//  LoginViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//
// 로그인 
import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "App_logo")
        view.addSubview(logoImageView)
        view.backgroundColor = .systemRed
    }
}

//#Preview {
//    var controller = LoginViewController()
//    return controller
//}

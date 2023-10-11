//
//  HomeViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//
// 홈(리스트)
import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    private var filterView = UIView()
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .systemRed
    }
}

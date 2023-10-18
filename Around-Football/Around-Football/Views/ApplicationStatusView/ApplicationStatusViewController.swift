//
//  ApplicationStatusViewController.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/18.
//

import UIKit

import SnapKit

class ApplicationStatusViewController: UIViewController {
    
    
    // MARK: Properties

    private let tableView = UITableView()

    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableViewConstraints()
    }
    
    // 화면에 진입할때마다 다시 테이블뷰 그리기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.reloadData()
    }
    
    
    // MARK: - Helpers

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ApplicationStatusTableViewCell.self, forCellReuseIdentifier: "ApplicationStatusTableViewCell")
    }
    
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalTo(view)
        }
    }
    
}



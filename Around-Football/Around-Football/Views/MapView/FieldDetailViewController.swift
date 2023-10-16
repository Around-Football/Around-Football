//
//  FieldDetailViewController.swift
//  Around-Football
//
//  Created by 진태영 on 10/13/23.
//

import UIKit

import Then
import SnapKit

final class FieldDetailViewController: UIViewController {
    
    var viewModel: FieldDetailViewModel
    
    // MARK: - Properties
    
    private let fieldNameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
    }
    
    private let addressLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let tableView = UITableView().then {
        $0.register(
            FieldRecruitTableViewCell.self,
            forCellReuseIdentifier: FieldRecruitTableViewCell.cellID
        )
        $0.backgroundColor = .systemPink
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: FieldDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresentStyle()
        configure()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configurePresentStyle() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            
            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
            sheetPresentationController.prefersGrabberVisible = true
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        let headerStackView = UIStackView(arrangedSubviews: [
            fieldNameLabel,
            addressLabel,
            underlineView
        ])
        
        headerStackView.axis = .vertical
        headerStackView.spacing = 10
        headerStackView.distribution = .equalSpacing
        
        view.addSubviews(
            headerStackView,
            tableView
        )
        
        underlineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        headerStackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
//        fieldNameLabel.snp.makeConstraints {
//            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
//            $0.centerY.equalToSuperview()
//        }
    }
    
    func configure() {
        fieldNameLabel.text = "구장이름"
        addressLabel.text = viewModel.field.fieldAddress
    }
    
    
}

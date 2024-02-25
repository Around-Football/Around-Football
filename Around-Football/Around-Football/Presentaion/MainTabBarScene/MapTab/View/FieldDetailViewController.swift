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
    
    // MARK: - Properties
    
    private let viewModel: FieldDetailViewModel
    
    private let headerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .equalSpacing
    }
    
    private let fieldNameLabel = UILabel().then {
        $0.textColor = AFColor.secondary
        $0.font = AFFont.titleMedium
        $0.numberOfLines = 0
    }
    
    private let addressLabel = UILabel().then {
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.text?.withSize(16)
        $0.numberOfLines = 0
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    
    private let tableView = UITableView().then {
        $0.register(
            FieldRecruitTableViewCell.self,
            forCellReuseIdentifier: FieldRecruitTableViewCell.identifier
        )
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
        configureCell()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configurePresentStyle() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            
            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
            sheetPresentationController.prefersGrabberVisible = true
        }
    }
    
    private  func configureCell() {
        fieldNameLabel.text = "구장이름"
        addressLabel.text = "주소"
        tableView.dataSource = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        headerStackView.addArrangedSubviews(fieldNameLabel,
                                            addressLabel)
        
        view.addSubviews(
            headerStackView,
            divider,
            tableView
        )
        
        headerStackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            $0.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            $0.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
        }
    }
}

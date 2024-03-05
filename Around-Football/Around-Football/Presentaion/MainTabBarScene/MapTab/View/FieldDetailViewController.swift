//
//  FieldDetailViewController.swift
//  Around-Football
//
//  Created by 진태영 on 10/13/23.
//

import UIKit

import RxCocoa
import RxSwift
import Then
import SnapKit

final class FieldDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: FieldDetailViewModel
    let disposeBag = DisposeBag()
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
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
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
        setUpTableView()
        setUpContents()
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
    
    private func setUpContents() {
        guard let fieldData = viewModel.fetchFieldData() else { return }
        fieldNameLabel.text = fieldData.fieldName
        addressLabel.text = fieldData.fieldAddress
    }
    
    private func setUpTableView() {
        let selectedItem = tableView.rx.modelSelected(Recruit.self)
        selectedItem
            .subscribe { recruit in
                self.dismiss(animated: true) {
                    self.viewModel.pushRecruitDetailView(recruit: recruit)
                }
            }.disposed(by: disposeBag)
            
        _ = viewModel.recruits
            .map { recruits in
                recruits.sorted { first, second in
                    first.matchDate.dateValue() > second.matchDate.dateValue()
                }
            }
            .bind(to: tableView.rx.items(
                cellIdentifier: FieldRecruitTableViewCell.identifier,
                cellType: FieldRecruitTableViewCell.self
            )) { [ weak self ] index, recruit, cell in
                guard let self else { return }
                cell.configure(recruit: recruit)
                cell.checkMyRecruit(result: viewModel.checkMyRecruit(recruit: recruit))
                cell.bindButton() {
                    self.viewModel.checkChannelAndPushChatViewController(recruit: recruit)
                    self.dismiss(animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        headerStackView.addArrangedSubviews(
            fieldNameLabel,
            addressLabel
        )
        
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

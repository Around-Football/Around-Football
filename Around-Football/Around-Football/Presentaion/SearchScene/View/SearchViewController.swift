//
//  SearchViewController.swift
//  Around-Football
//
//  Created by 강창현 on 11/13/23.
//

import UIKit

import RxSwift
import SnapKit
import Then

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView().then {
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
    }
    
    private let disposeBag = DisposeBag()
    
    var searchViewModel: SearchViewModel
    
    private lazy var searchTextField = UITextField().then {
        $0.placeholder = "장소를 검색해주세요."
        guard let image = UIImage(systemName: "magnifyingglass") else { return }
        $0.setLeftView(image: image, imageColor: AFColor.grayScale300)
        $0.clearButtonMode = .whileEditing
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    
    // MARK: - Lifecycles
    
    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AFColor.grayScale200
        ]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchViewModel.coordinator?.dismissSearchViewController()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "장소 찾기"
        view.addSubviews(searchTextField,
                         divider,
                         tableView)
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
        }
    }
    
    private func setTableView() {
        tableView.register(SearchTableViewCell.self,
                           forCellReuseIdentifier: SearchTableViewCell.cellID)
        tableView.dataSource = nil
        
        let selectedItem = tableView.rx.modelSelected(Place.self)
        
        selectedItem
            .subscribe(onNext: { [weak self] place in
                guard let self = self else { return }
                searchViewModel.dataSubject
                    .onNext(place)
                searchViewModel.coordinator?.dismissSearchViewController()
            })
            .disposed(by: disposeBag)
        
        _ = searchViewModel.searchResults
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchTableViewCell.cellID,
                cellType: SearchTableViewCell.self)) { index, place, cell in
                    cell.fieldNameLabel.text = place.name
                    cell.fieldAddressLabel.text = place.address
                }
                .disposed(by: disposeBag)
    }
    
    @objc
    private func textFieldDidChange(_ sender: Any?) {
        guard let keyword = searchTextField.text else { return }
        searchViewModel.searchFields(keyword: keyword, disposeBag: disposeBag)
    }
}

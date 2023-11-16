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
    
    private let tableView = UITableView() 
    
    private let disposeBag = DisposeBag()
    
    var viewModel: SearchViewModel
    
    var searchResultsController = SearchResultViewController()
    
    private lazy var searchController = UISearchController(searchResultsController: searchResultsController)
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar().then {
            $0.placeholder = "장소를 검색해주세요."
            $0.delegate = self
        }
        return searchBar
    }()

    
    var searchPlaces: [Place] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        setTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.coordinator.dismissSearchViewController()
    }
    
    // MARK: - Helpers
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
    }

    private func configureUI() {
        view.backgroundColor = .white
//        
//        tableView.delegate = self
//        tableView.dataSource = self
        view.addSubviews(searchBar,
                         tableView)
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
        }
    }
    
    private func setTableView() {
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.cellID)
        tableView.dataSource = nil
        
        _ = viewModel.searchResults
            .debug()
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.cellID, cellType: SearchTableViewCell.self)) { index, place, cell in
                cell.fieldNameLabel.text = place.name
                cell.fieldAddressLabel.text = place.address
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        tableView.reloadData()
        viewModel.searchField(searchText)
        // searchPlaces = viewModel.searchPlaces
        var i : [Place] = []
        let a = viewModel.searchResults.map { place in
            i = place
        }
        
        print("=========ViewController: \(i)=========")
    }
}

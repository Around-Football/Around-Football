//
//  HomeTableViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
////
//
//import UIKit
//
//import RxCocoa
//import RxSwift
//import SnapKit
//import Then
//
//TODO: - HomeTableViewController 삭제

//final class HomeTableViewController: UITableViewController {
//    
//    // MARK: - Properties
//    var viewModel: HomeViewModel
//    private let disposeBag = DisposeBag()
//    
//    private var invokedViewDidLoad = PublishSubject<Void>()
//    
//    init(viewModel: HomeViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Lifecyles
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureUI()
//    }
//    
//    private func configureUI() {
//        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
//        tableView.dataSource = nil
//        
////        viewModel.recruitObservable
////            .observe(on: MainScheduler.instance)
////            .bind(to: tableView.rx.items(cellIdentifier: HomeTableViewCell.id,
////                                         cellType: HomeTableViewCell.self)
////            ) { index, item, cell in
////                cell.bindContents(item: item)
////            }
////            .disposed(by: disposeBag)
//        
//                let input = HomeViewModel1.Input(invokedViewDidLoad: invokedViewDidLoad.asObservable())
//        
//                let output = viewModel.transform(input)
//        
//                output
//                    .recruitList
//                    .bind(to: tableView.rx.items(cellIdentifier: HomeTableViewCell.id,
//                                                     cellType: HomeTableViewCell.self)) { index, item, cell in
//                        cell.bindContents(item: item)
//                    }.disposed(by: disposeBag)
//                
////                        //프린트됨
////                        FirebaseAPI.shared.readRecruitRx()
////                            .subscribe(onNext: { recruits in
////        
////                                print("recruits: \(recruits)")
////                            })
////                            .disposed(by: disposeBag)
//    }
//    
//    // MARK: - Selectors
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.coordinator?.pushToDetailView()
//    }
//}



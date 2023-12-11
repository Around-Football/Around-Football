//
//  WrittenPostViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/10/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class WrittenPostViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: InfoPostViewModel
    private let loadWrittenPost: PublishSubject<Void> = PublishSubject()
    private let disposeBag = DisposeBag()

    private var writtenPostTableView = UITableView().then {
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: InfoPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureUI()
        bindUI()
        loadWrittenPost.onNext(())
    }
    
    // MARK: - Helpers
    
    private func bindUI() {
        let input = InfoPostViewModel.Input(loadPost: loadWrittenPost.asObservable())
        
        let output = viewModel.transform(input)
        
        output
            .writtenList
            .bind(to: writtenPostTableView.rx.items(cellIdentifier: HomeTableViewCell.id,
                                             cellType: HomeTableViewCell.self)) { index, item, cell in
                cell.bindContents(item: item)
                cell.configureButtonTap()
            }.disposed(by: disposeBag)
        
        writtenPostTableView.rx.modelSelected(Recruit.self)
            .subscribe(onNext: { [weak self] selectedRecruit in
                guard let self else { return }
                handleItemSelected(recruitItem: selectedRecruit)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleItemSelected(recruitItem: Recruit) {
        viewModel.coordinator?.pushDetailCell(recruitItem: recruitItem)
    }
    
    private func configureUI() {
        title = "작성 글"
        view.addSubview(writtenPostTableView)
        writtenPostTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

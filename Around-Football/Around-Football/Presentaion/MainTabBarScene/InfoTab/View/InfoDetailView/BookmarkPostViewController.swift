//
//  BookmarkPostViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/10/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class BookmarkPostViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: InfoPostViewModel
    private let loadBookmarkPost: PublishSubject<Void> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    private lazy var emptyView = EmptyAFView(type: EmptyAFView.SettingTitle.bookmark).then {
        $0.isHidden = true
    }

    private var bookmarkTableView = UITableView().then {
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
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
        configureUI()
        bindUI()
        loadBookmarkPost.onNext(())
    }
    
    private func bindUI() {
        let input = InfoPostViewModel.Input(loadPost: loadBookmarkPost.asObservable())
        
        let output = viewModel.transform(input)
        
        output
            .bookmarkList
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] recruits in
                guard let self else { return }
                emptyView.isHidden = recruits.isEmpty ? false : true
            })
            .bind(to: bookmarkTableView.rx.items(cellIdentifier: HomeTableViewCell.id,
                                             cellType: HomeTableViewCell.self)) { [weak self] index, item, cell in
                guard let self else { return }
                cell.infoPostViewModel = viewModel
                cell.bindContents(item: item, isBookmark: true)
                cell.configureButtonTap()
            }.disposed(by: disposeBag)
        
        bookmarkTableView.rx.modelSelected(Recruit.self)
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
        title = "관심 글"
        view.backgroundColor = .white
        
        view.addSubviews(bookmarkTableView,
                        emptyView)
        
        bookmarkTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

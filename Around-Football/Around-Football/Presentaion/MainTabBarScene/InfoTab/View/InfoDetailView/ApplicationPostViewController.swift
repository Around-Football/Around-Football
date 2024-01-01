//
//  ApplicationPostViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/10/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

//TODO: - 파베 쿼리 이슈로 현재 승인 말고 딱 신청한 글만 나옴. 나중에 승인된 글과 신청한 글 어떻게 처리할지 논의하기

final class ApplicationPostViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: InfoPostViewModel
    private let loadApplicationPost: PublishSubject<Void> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    private let emptyLabel = UILabel().then {
        $0.text = "아직 신청 글이 없습니다.\n참여 신청을 해주세요."
        $0.numberOfLines = 2
        $0.font = AFFont.titleMedium
        $0.isHidden = true
    }

    private var applicationPostTableView = UITableView().then {
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
        loadApplicationPost.onNext(())
    }
    
    // MARK: - Helpers
    
    private func bindUI() {
        let input = InfoPostViewModel.Input(loadPost: loadApplicationPost.asObservable())
        
        let output = viewModel.transform(input)
        
        output
            .applicationList
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] recruits in
                guard let self else { return }
                emptyLabel.isHidden = recruits.isEmpty ? false : true
            })
            .bind(to: applicationPostTableView.rx.items(cellIdentifier: HomeTableViewCell.id,
                                             cellType: HomeTableViewCell.self)) { index, item, cell in
                cell.bindContents(item: item)
                cell.configureButtonTap()
            }.disposed(by: disposeBag)
        
        applicationPostTableView.rx.modelSelected(Recruit.self)
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
        title = "신청 글"
        view.backgroundColor = .white
        
        view.addSubview(applicationPostTableView)
        applicationPostTableView.addSubview(emptyLabel)
        
        applicationPostTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

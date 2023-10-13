//
//  FieldDetailViewController.swift
//  Around-Football
//
//  Created by 진태영 on 10/13/23.
//

import UIKit

import Then
import SnapKit

class FieldDetailViewController: UIViewController {
    
    var viewModel: FieldDetailViewModel

    // MARK: - Properties
    
    private let labelView = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 11)
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
        self.labelView.text = viewModel.id
        view.addSubviews(labelView)
        
        labelView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.centerY.equalToSuperview()
        }
    }


}

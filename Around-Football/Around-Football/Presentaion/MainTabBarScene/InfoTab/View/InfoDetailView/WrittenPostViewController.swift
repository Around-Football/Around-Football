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

class WrittenPostViewController: UIViewController {
    
    var viewModel: InfoPostViewModel?
    
    init(viewModel: InfoPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
}

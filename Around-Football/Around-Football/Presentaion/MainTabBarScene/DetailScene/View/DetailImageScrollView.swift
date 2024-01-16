//
//  DetailImageScrollView.swift
//  Around-Football
//
//  Created by 진태영 on 1/4/24.
//

import UIKit

import SnapKit
import Then

final class DetailImageScrollView: UIView {
    
    // MARK: - Properties
    
    private let imageScrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let imageNumberLabel = UILabel().then {
        $0.text = "1"
        $0.textColor = .white
        $0.font = AFFont.filterDay
    }
    
    private let imageMaxNumberLabel = UILabel().then {
        $0.text = "1"
        $0.textColor = .white
        $0.alpha = 0.5
        $0.font = AFFont.filterDay
    }
    
    private lazy var imageNumberStackOuterView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 9
        $0.addSubview(imageNumberStackView)
    }
    
    private lazy var imageNumberStackView = UIStackView().then { view in
        let subViews = [imageNumberLabel,
                        createHDividerView(),
                        imageMaxNumberLabel]
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.clipsToBounds = true
        
        subViews.forEach { label in
            view.addArrangedSubview(label)
        }
    }

    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(images: [UIImage?]) {
        imageScrollView.delegate = self

        if images.isEmpty {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "DefaultRecruitImage")
            imageScrollView.addSubview(imageView)
            configureImageViewUI(imageView: imageView, index: 0, count: 1)
            
            return
        }
        
        for index in 0..<images.count {
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            imageView.image = images[index]
            configureImageViewUI(imageView: imageView, index: index, count: images.count)
        }
        imageMaxNumberLabel.text = "\(images.count)"
    }
    
    private func configureImageViewUI(imageView: UIImageView, index: Int, count: Int) {
        imageScrollView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.width.equalTo(imageScrollView)
            make.height.equalTo(imageScrollView)
            make.top.equalTo(imageScrollView)
            if index == 0 {
                make.leading.equalTo(imageScrollView)
            } else {
                make.leading.equalTo(imageScrollView.subviews[index - 1].snp.trailing)
            }
        }
        
        if index == count - 1 {
            imageView.snp.makeConstraints { make in
                make.trailing.equalTo(imageScrollView)
            }
        }
    }
    
    private func configureUI() {
        addSubviews(imageScrollView,
                    imageNumberStackOuterView)
        imageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageNumberStackOuterView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-11)
            $0.width.equalTo(40)
            $0.height.equalTo(18)
        }
        
        imageNumberStackView.snp.makeConstraints {
            $0.edges.equalTo(imageNumberStackOuterView).inset(UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
        }
    }
    
    
    private func createHDividerView() -> UIView {
        return UIView().then {
            $0.backgroundColor = AFColor.grayScale300
            $0.snp.makeConstraints { make in
                make.width.equalTo(0.4)
                make.height.equalTo(8)
            }
        }
    }

}

extension DetailImageScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(imageScrollView.contentOffset.x / imageScrollView.frame.size.width)
        self.imageNumberLabel.text = "\(page + 1)"
    }
}

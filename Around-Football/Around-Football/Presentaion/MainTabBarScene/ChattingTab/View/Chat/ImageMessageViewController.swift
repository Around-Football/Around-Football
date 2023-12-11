//
//  ImageMessageViewController.swift
//  Around-Football
//
//  Created by 진태영 on 11/15/23.
//

import UIKit

import SnapKit

class ImageMessageViewController: UIViewController {
    
    // MARK: - Properties
    
    var image: UIImage?
    lazy var panGestureRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handleDismissGesture(_:))
    )
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.tintColor = .gray
        
        return button
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(panGestureRecognizer)
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc
    private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func handleDismissGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let velocity = gesture.velocity(in: gesture.view)
        
        switch gesture.state {
        case .changed:
            if translation.y >= 0 { // 스와이프할 때 view의 높이 조절
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if velocity.y >= 1500 {
                dismiss(animated: true)
            } else {
                // 만약 스왑이 충분하지 않다면 원래대로 이동
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .black
        view.addSubviews(
            imageView,
            closeButton
        )
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
            $0.height.width.equalTo(40)
        }
    }
}

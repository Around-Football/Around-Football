//
//  ImageTransition.swift
//  Around-Football
//
//  Created by 진태영 on 11/15/23.
//

import UIKit

import SnapKit

class ImageTransition: UIPercentDrivenInteractiveTransition {
    var originPoint: CGPoint?
    var originFrame: CGRect?
    
    func setPoint(point: CGPoint?) {
        self.originPoint = point
    }
    
    func setFrame(frame: CGRect?) {
        self.originFrame = frame
    }
}

extension ImageTransition: UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        // 다음 보여질 뷰 참조
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        toView.frame = CGRect(origin: originPoint!, size: originFrame!.size)
        
        toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) // 초기 뷰 0.8배로 축소
        containerView.addSubview(toView)
        
        // hierarchy on top
        containerView.bringSubviewToFront(toView)
        
        toView.layer.masksToBounds = true
        toView.layer.cornerRadius = 20
        toView.alpha = 0 // 초기 뷰 알파 0
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 1.0, // 0.0에 가까울수록 심하게 튕기고 1.0이면 안튕김
                       initialSpringVelocity: 0.1, // 0.0에 가까울수록 튕길 때 속도 빠름
                       options: .curveEaseOut
        ) {
            toView.transform = .identity // 원래 자리로 되돌아오면서 애니메이션 이동 효과
            toView.alpha = 1
        } completion: { _ in
            toView.translatesAutoresizingMaskIntoConstraints = false
            toView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.1) {
                containerView.layoutIfNeeded()
            }
        }
        transitionContext.completeTransition(true)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
}

//
//  DisMissAnimation.swift
//  Around-Football
//
//  Created by 진태영 on 11/15/23.
//

import UIKit

class DisMissAnim: UIPercentDrivenInteractiveTransition {
    
}

extension DisMissAnim: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        let duration = transitionDuration(using: transitionContext)
        let finalFrame = fromView.frame.offsetBy(dx: 0, dy: fromView.frame.height)
        
        UIView.animate(withDuration: duration) {
            fromView.frame = finalFrame
        } completion: { bool in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

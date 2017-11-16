//
//  FlipPresentAnimationController.swift
//  CustomTransitions
//
//  Created by lihuiHan on 2017/11/15.
//  Copyright © 2017年 lihuihan. All rights reserved.
//

import UIKit

class FlipAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    private var originFrame: CGRect
    private var presenting: Bool
    let interactionController: SwipeInteractionController?
    
    init(originFrame: CGRect, presenting: Bool, interactionController:SwipeInteractionController?) {
        self.originFrame = originFrame
        self.presenting = presenting
        self.interactionController = interactionController
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        guard let snapshot = presenting ? toVC.view.snapshotView(afterScreenUpdates: true) : fromVC.view.snapshotView(afterScreenUpdates: true) else {
            return
        }
        
        snapshot.layer.cornerRadius = 15.0
        snapshot.layer.masksToBounds = true
        
        let containerView = transitionContext.containerView
        
        let finalFrame = presenting ? transitionContext.finalFrame(for: toVC) : originFrame
        originFrame = presenting ? originFrame : fromVC.view.frame
        
        snapshot.frame = originFrame
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        
        perspectiveTransform(for: containerView)
        
        if presenting {
            snapshot.layer.transform = yRotation(.pi/2)
            toVC.view.isHidden = true
        }else {
            toVC.view.layer.transform = yRotation(-.pi/2)
            fromVC.view.isHidden = true
        }
        
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            if self.presenting {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                    fromVC.view.layer.transform = self.yRotation(-.pi/2)
                })
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                    snapshot.layer.transform = self.yRotation(0.0)
                })
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    snapshot.frame = finalFrame
                    snapshot.layer.cornerRadius = 0.0
                })
                
            }else {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                    snapshot.frame = finalFrame
                })
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                    snapshot.layer.transform = self.yRotation(.pi/2)
                })
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    toVC.view.layer.transform = self.yRotation(0.0)
                })
            }
            
        }) { _ in
            
            if self.presenting {
                toVC.view.isHidden = false
                snapshot.removeFromSuperview()
                fromVC.view.layer.transform = CATransform3DIdentity
            }else {
                fromVC.view.isHidden = false
                snapshot.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    toVC.view.removeFromSuperview()
                }
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    // MARK: - methods
    func yRotation(_ angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    func perspectiveTransform(for containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
    }
}


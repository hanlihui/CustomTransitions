//
//  SwipeInteractionController.swift
//  CustomTransitions
//
//  Created by lihuiHan on 2017/11/15.
//  Copyright © 2017年 lihuihan. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    private var shouldCompleteTransiton = false
    private var presenting: Bool!
    private weak var presentingViewController: UIViewController?
    private weak var presentedViewController: UIViewController?
    
    init(presentingViewController: UIViewController?, presentedViewController: UIViewController?, presenting:Bool) {
        super.init()
        self.presentingViewController  = presentingViewController
        self.presentedViewController = presentedViewController
        self.presenting = presenting
        prepareGestureRecognizer()
    
    }
    
    func prepareGestureRecognizer() {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        if presenting {
            guard let  presentingViewController = presentingViewController else {
                return
            }
            gesture.edges = .right
            presentingViewController.view.addGestureRecognizer(gesture)
        }else {
            
            guard let  presentedViewController = presentedViewController else {
                return
            }
            gesture.edges = .left
            presentedViewController.view.addGestureRecognizer(gesture)
        }
        
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let transition = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = transition.x / 200
        progress = CGFloat(fminf(fmaxf(Float(fabs(progress)), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            if presenting {
                presentingViewController!.present(presentedViewController!, animated: true, completion: nil)
            }else {
                presentedViewController!.dismiss(animated: true, completion: nil)
            }
            
        case .changed:
            shouldCompleteTransiton = progress > 0.5
            update(progress)
            
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransiton {
                finish()
            } else {
                cancel()
            }
            
        default:
            break
        }
    }
}

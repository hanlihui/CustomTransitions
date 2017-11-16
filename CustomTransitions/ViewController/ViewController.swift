//
//  ViewController.swift
//  CustomTransitions
//
//  Created by lihuiHan on 2017/11/14.
//  Copyright © 2017年 lihuihan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    var persentInteractionController: SwipeInteractionController?
    var detailViewController: DetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.transitioningDelegate = self
        
        persentInteractionController = SwipeInteractionController(presentingViewController: self, presentedViewController: detailViewController, presenting: true)
    }

    @IBAction func handleTap() {
        performSegue(withIdentifier: "DetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue",
            let destinationViewController = segue.destination as? DetailViewController {
            destinationViewController.transitioningDelegate = self
        }
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlipAnimationController(originFrame: cardView.frame, presenting: true, interactionController: persentInteractionController)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let detailVC = dismissed as? DetailViewController else {
            return nil
        }
        return FlipAnimationController(originFrame: cardView.frame, presenting: false, interactionController:detailVC.swipeInteractionController)
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? FlipAnimationController,
            let interactionController = animator.interactionController,
            interactionController.interactionInProgress else {
                return nil
        }
        return interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? FlipAnimationController,
            let interactionController = animator.interactionController,
            interactionController.interactionInProgress else {
                return nil
        }
        return interactionController
    }
    
}

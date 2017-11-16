//
//  DetailViewController.swift
//  CustomTransitions
//
//  Created by lihuiHan on 2017/11/14.
//  Copyright © 2017年 lihuihan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var swipeInteractionController: SwipeInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeInteractionController = SwipeInteractionController(presentingViewController: nil, presentedViewController: self, presenting: false)
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

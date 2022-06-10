//
//  BaseTabbarViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit

class BaseTabbarViewController: UITabBarController, Storyboarded {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 1
        tabBar.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        tabBar.layer.shadowOpacity = 0.4
    }
    



}

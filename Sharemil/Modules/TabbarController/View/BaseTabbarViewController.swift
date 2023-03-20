//
//  BaseTabbarViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit

class BaseTabbarViewController: UITabBarController, Storyboarded {
    
    var viewModel: TabbarControllerViewModel!
    
    var carts: [Cart]? {
        didSet {
            if let tabItems = self.tabBar.items {
                
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[1]
                tabItem.badgeColor = .black
                if carts?.isEmpty ?? true {
                    tabItem.badgeValue = nil
                } else {
                    tabItem.badgeValue = "\(carts?.count ?? 0)"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        self.viewModel.fetchCarts()
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 1
        tabBar.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        tabBar.layer.shadowOpacity = 0.4
        NotificationCenter.default.addObserver(self, selector: #selector(cartBadge), name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
    }
    
    func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.carts.bind { cartItems in
            self.carts = cartItems?.carts
        }

    }
    
    

    @objc private func cartBadge() {
        self.viewModel.fetchCarts()
    }

}

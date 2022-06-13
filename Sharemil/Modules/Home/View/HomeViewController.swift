//
//  HomeViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = HomeViewModel()
        
    }
}

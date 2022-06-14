//
//  HomeViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.viewModel = HomeViewModel()
        self.viewModel.fetchChefBy(location: LLocation.init(location: nil), name: "")
    }
    
    func setup() {
        searchContainer.addBorder(.black)
        searchContainer.rounded()
        shadow.setStandardBoldShadow()
        shadow.rounded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
    }
}

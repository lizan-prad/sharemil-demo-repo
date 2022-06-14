//
//  HomeViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    var viewModel: HomeViewModel!
    
    var chefs: [ChefListModel]? {
        didSet {
            tableView.reloadData()
            self.tableHeight.constant = CGFloat((chefs?.count ?? 0)*220) + 8
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setTableView()
        self.viewModel = HomeViewModel()
        bindViewModel()
        self.viewModel.fetchChefBy(location: LLocation.init(location: nil), name: "")
        searchField.addTarget(self, action: #selector(searchAction(_:)), for: .editingChanged)
    }
    
    @objc func searchAction(_ sender: UITextField) {
        self.viewModel.fetchChefBy(location: LLocation.init(location: nil), name: sender.text ?? "")
    }
    
    private func setup() {
        searchContainer.addBorder(.black)
        searchContainer.rounded()
        shadow.setStandardBoldShadow()
        shadow.rounded()
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "HomeChefTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeChefTableViewCell")
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
        self.viewModel.success.bind { models in
            self.chefs = models
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chefs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChefTableViewCell") as! HomeChefTableViewCell
        cell.setup()
        cell.chef = self.chefs?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

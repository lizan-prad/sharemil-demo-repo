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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    
    var viewModel: HomeViewModel!
    
    var chefs: [ChefListModel]? {
        didSet {
            self.filtered = chefs
        }
    }
    
    var filtered: [ChefListModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedCusine: CusineListModel? {
        didSet {
            self.filtered = chefs?.filter({$0.cuisineId == selectedCusine?.id})
        }
    }
    
    var cusines: [CusineListModel]? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setTableView()
        setCollectionView()
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
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: "HomeCusinesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCusinesCollectionViewCell")
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
        self.viewModel.cusines.bind { models in
            self.cusines = models
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChefTableViewCell") as! HomeChefTableViewCell
        cell.setup()
        cell.chef = self.filtered?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cusines?.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCusinesCollectionViewCell", for: indexPath) as! HomeCusinesCollectionViewCell
        if indexPath.row == 0 {
            cell.cusineLabel.text = "All"
            cell.cusinesImage.image = UIImage.init(named: "all-cuisine")
        } else {
            cell.model = self.cusines?[indexPath.row - 1]
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.filtered = self.chefs
            return
        }
        self.selectedCusine = self.cusines?[indexPath.row - 1]
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 86, height: 85)
    }
}

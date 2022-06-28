//
//  ChefMenuItemViewController.swift
//  Sharemil
//
//  Created by lizan on 21/06/2022.
//

import UIKit
import SDWebImage
import CoreLocation

class ChefMenuItemViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemDescLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemNamelabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var menuItemImage: UIImageView!
    
    var viewModel: MenuItemViewModel!
    var selectedOption: (String, Int)? {
        didSet {
            self.tableView.reloadRows(at: model?.options?[selectedOption?.1 ?? 0].choices?.enumerated().map({IndexPath.init(row: $0.offset, section: selectedOption?.1 ?? 0)}) ?? [], with: .none)
        }
    }
    
    var cartModel: [CartItems]?
    
    var didAddToCart: ((CartListModel?) -> ())?
    
    var selectedOptions = [MenuItemOptionsModel]() {
        didSet {
            validateAddToCart()
        }
    }
    
    
    var initialQuantity = 1 {
        didSet {
            self.quantityLabel.text = "\(initialQuantity)"
            self.addToCartBtn.setTitle("Add \(initialQuantity) to cart · $\(Double(initialQuantity)*(model?.price ?? 0))", for: .normal)
        }
    }
    
    var model: ChefMenuListModel? {
        didSet {
            self.setupData()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setTableView()
        setupView()
        self.viewModel.fetchChefMenuItem()
        GoogleMapsServices.shared.getRoutes(CLLocationCoordinate2D.init(), destination: CLLocationCoordinate2D.init()) { _ in
            
        }
    }
    
    private func setupView() {
        self.plusBtn.rounded()
        self.minusBtn.rounded()
        self.closeBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        self.plusBtn.addTarget(self, action: #selector(plusAction), for: .touchUpInside)
        self.minusBtn.addTarget(self, action: #selector(minusAction), for: .touchUpInside)
        self.addToCartBtn.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
    }
    
    @objc func addToCart() {
        if cartModel?.isEmpty ?? true {
            self.viewModel.addToCart(self.model?.chefId ?? "", itemId: self.model?.id ?? "", quantity: self.initialQuantity, options: selectedOptions)
        } else {
            var item = CartItems.init()
            item.id = self.cartModel?.first?.id
            item.cartId = self.cartModel?.first?.cartId
            item.menuItemId = self.model?.id
            item.quantity = self.initialQuantity
            item.options = self.selectedOptions
            var cart: [CartItems] = self.cartModel ?? []
            cart = cart.filter({$0.menuItemId != self.model?.id})
            cart.append(item)
            self.viewModel.updateToCart(self.model?.chefId ?? "", cartModels: cart)
        }
    }
    
    @objc func plusAction() {
        self.initialQuantity += 1
    }
    
    @objc func minusAction() {
        initialQuantity = self.initialQuantity == 1 ? 1 : (initialQuantity - 1)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    private func validateAddToCart() {
        self.addToCartBtn.isEnabled = (self.model?.options?.isEmpty ?? true) ? true : ( self.model?.options?.count == self.selectedOptions.count)
    }
    
    private func setupData() {
        self.menuItemImage.sd_setImage(with: URL.init(string: model?.imageUri ?? ""))
        self.itemNamelabel.text = model?.name
        self.itemDescLabel.text = model?.description
        self.itemPriceLabel.text = "$\(model?.price ?? 0)"
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        viewModel.itemModel.bind { model in
            self.model = model
            self.validateAddToCart()
        }
        viewModel.cartList.bind { model in
            self.dismiss(animated: true) {
                self.didAddToCart?(model)
            }
        }
    }

    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.register(UINib.init(nibName: "ChefMenuOptionRadioTableViewCell", bundle: nil), forCellReuseIdentifier: "ChefMenuOptionRadioTableViewCell")
        tableView.register(UINib.init(nibName: "ChefMenuOptionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ChefMenuOptionHeaderTableViewCell")
        tableView.register(UINib.init(nibName: "ChefMenuOptionCheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "ChefMenuOptionCheckBoxTableViewCell")
    }
}

extension ChefMenuItemViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return model?.options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.options?[section].choices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if model?.options?[indexPath.section].multipleChoice == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChefMenuOptionCheckBoxTableViewCell") as! ChefMenuOptionCheckBoxTableViewCell
            cell.optionName.text = model?.options?[indexPath.section].choices?[indexPath.row]
            cell.setup()
            cell.section = indexPath.section
            cell.didSelect = { (val, section) in
                if self.selectedOptions.isEmpty == true || section > (self.selectedOptions.count - 1) {
                    var check = MenuItemOptionsModel()
                    check.title = self.model?.options?[indexPath.section].title
                    check.multipleChoice = self.model?.options?[indexPath.section].multipleChoice
                    check.choices = [val]
                    self.selectedOptions.append(check)
                } else if section <= (self.selectedOptions.count - 1) {
                    var check = self.selectedOptions[section]
                    var choices: [String] = check.choices ?? []
                    choices.append(val)
                    check.choices = choices
                    self.selectedOptions.remove(at: section)
                    self.selectedOptions.insert(check, at: section)
                }
            }
            cell.didDeSelect = { (val, section) in
                var check = self.selectedOptions[section]
                let choices: [String] = check.choices?.filter({$0 != val}) ?? []
                check.choices = choices
                self.selectedOptions.remove(at: section)
                self.selectedOptions.insert(check, at: section)
                if choices.isEmpty == true {
                    self.selectedOptions.remove(at: section)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChefMenuOptionRadioTableViewCell") as! ChefMenuOptionRadioTableViewCell
            cell.optionName.text = model?.options?[indexPath.section].choices?[indexPath.row]
            cell.section = indexPath.section
            cell.setup()
            cell.radioButton.isOn = cell.optionName.text == selectedOption?.0 
            cell.didSelect = { (val,section) in
                self.selectedOption = (val, section)
                if self.selectedOptions.isEmpty == true || section > (self.selectedOptions.count - 1) {
                    var check = MenuItemOptionsModel()
                    check.title = self.model?.options?[indexPath.section].title
                    check.multipleChoice = self.model?.options?[indexPath.section].multipleChoice
                    check.choices = [val]
                    self.selectedOptions.append(check)
                } else if section <= (self.selectedOptions.count - 1) {
                    var check = self.selectedOptions[section]
                    check.choices = [val]
                    self.selectedOptions.remove(at: section)
                    self.selectedOptions.insert(check, at: section)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefMenuOptionHeaderTableViewCell") as! ChefMenuOptionHeaderTableViewCell
        cell.headerTitle.text = model?.options?[section].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

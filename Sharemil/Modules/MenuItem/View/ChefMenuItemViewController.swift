//
//  ChefMenuItemViewController.swift
//  Sharemil
//
//  Created by lizan on 21/06/2022.
//

import UIKit
import SDWebImage
import CoreLocation
import FirebaseAuth
class ChefMenuItemViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var itemLeftView: UIView!
    @IBOutlet weak var itemLeft: UILabel!
    @IBOutlet weak var quantityStack: UIStackView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
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
    
    var isUpdate = false
    var updateItem = false
    
    var didAddToCart: ((String?) -> ())?
    var didRemove: ((String?) -> ())?
    
    var selectedOptions = [MenuItemOptionsModel]() {
        didSet {
            validateAddToCart()
            self.getQuantity()
        }
    }
    
    var selectedItem: CartItems?
    
    
    var initialQuantity = 1 {
        didSet {
            
            self.getQuantity()
        }
    }
    
    func getQuantity() {
        self.quantityLabel.text = "\(initialQuantity)"
        if cartModel?.filter({$0.menuItemId == self.model?.id}).isEmpty ?? true {
            let options = self.selectedOptions.map({$0.choices?.map({$0.price ?? 0}).reduce(0, +) ?? 0}).reduce(0,+)
            self.addToCartBtn.setTitle("\(isUpdate ? "Update" : "Add") \(initialQuantity) to cart · $\((Double(initialQuantity)*((model?.price ?? 0) + options)).withDecimal(2))", for: .normal)
        } else {
            let options = self.selectedOptions.map({$0.choices?.map({$0.price ?? 0}).reduce(0, +) ?? 0}).reduce(0,+)
            self.addToCartBtn.setTitle("\(isUpdate ? "Update" : "Add") \(initialQuantity) to cart · $\((Double(initialQuantity)*((model?.price ?? 0) + options)).withDecimal(2))", for: .normal)
        }
    }
    
    var model: ChefMenuListModel? {
        didSet {
            self.setupData()
            tableView.reloadData()
            self.tableHeight.constant = CGFloat((self.model?.options?.count ?? 0)*60) + CGFloat((self.model?.options?.map({$0.choices ?? []}).flatMap({$0}).count ?? 0)*40) + 200
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setTableView()
        setupView()
        if UIDevice.current.hasNotch {
            self.containerHeight.constant = 116
        } else {
            self.containerHeight.constant = 74
        }
        if isUpdate {
            self.selectedOptions = self.selectedItem?.options ?? []
        }
        
        self.viewModel.fetchChefMenuItem()
        GoogleMapsServices.shared.getRoutes(CLLocationCoordinate2D.init(), destination: CLLocationCoordinate2D.init()) { _ in
            
        }
    }
    
    private func start() {
        self.showProgressHud()
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { token, error in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                UserDefaults.standard.set(token, forKey: StringConstants.userIDToken)
                self.viewModel.fetchChefMenuItem()
            }
        })
    }
    
    func setupUpdateView() {
        if isUpdate {
            //            self.tableView.alpha = 0.7
            //            self.quantityStack.isHidden = true
            self.removeBtn.isHidden = false
            self.initialQuantity = selectedItem?.quantity ?? 0
            let opt = self.selectedItem?.options?.map({$0.choices?.map({$0.price ?? 0}).reduce(0, +) ?? 0})
            let options = opt?.reduce(0,+) ?? 0
            self.addToCartBtn.setTitle("Update \(selectedItem?.quantity ?? 0) to cart · $\((Double(initialQuantity)*((model?.price ?? 0) + options)).withDecimal(2))", for: .normal)
            //            self.plusBtn.alpha = 0.7
            //            self.minusBtn.alpha = 0.7
            //            self.plusBtn.isEnabled = false
            //            self.minusBtn.isEnabled = false
        } else {
            self.quantityStack.isHidden = false
            self.removeBtn.isHidden = true
            self.plusBtn.isEnabled = true
            self.minusBtn.isEnabled = true
        }
    }
    
    private func setupView() {
        self.plusBtn.rounded()
        self.minusBtn.rounded()
        self.closeBtn.rounded()
        self.closeBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        self.plusBtn.addTarget(self, action: #selector(plusAction), for: .touchUpInside)
        self.minusBtn.addTarget(self, action: #selector(minusAction), for: .touchUpInside)
        self.addToCartBtn.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        let alert = AlertServices.showAlertWithOkCancelAction(title: nil, message: "Do you wish to delete this item?") { _ in
            self.cartModel = self.cartModel?.filter({$0.id != self.selectedItem?.id})
            if self.cartModel?.isEmpty ?? true {
                self.viewModel.deleteCart(self.selectedItem?.cartId ?? "")
            } else {
                self.viewModel.updateToCart(self.selectedItem?.menuItem?.chefId ?? "", cartModels: self.cartModel ?? [])
            }
        }
        self.present(alert, animated: true)
    }
    
    @objc func addToCart() {
        if cartModel?.isEmpty ?? true {
            self.viewModel.addToCart(self.model?.chefId ?? "", itemId: self.model?.id ?? "", quantity: self.initialQuantity, options: selectedOptions)
        } else {
            var item = CartItems.init()
            //            item.id = self.cartModel?.first?.id
            //            item.cartId = self.cartModel?.first?.cartId
            item.menuItemId = self.model?.id
   
                item.quantity = self.initialQuantity - (self.selectedItem?.quantity ?? 0)
          
            
            item.options = self.selectedOptions
            var cart: [CartItems] = self.cartModel ?? []
            //            cart = cart.filter({$0.menuItemId != self.model?.id})
            cart.append(item)
            self.viewModel.updateToCart(self.model?.chefId ?? "", cartModels: cart)
        }
    }
    
    @objc func plusAction() {
        if model?.remainingItems == 0 && model?.remainingItems != nil {
            self.initialQuantity += 1
        } else {
            if (self.model?.remainingItems ?? 0) > self.initialQuantity {
                self.initialQuantity += 1
            } else if self.model?.remainingItems == nil {
                self.initialQuantity += 1
            }
        }
    }
    
    @objc func minusAction() {
        initialQuantity = self.initialQuantity == 1 ? 1 : (initialQuantity - 1)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    private func validateAddToCart() {
        if (self.model?.options?.isEmpty ?? true) {
            self.setupUpdateView()
        } else {
            (self.model?.options?.count ?? 0) == self.selectedOptions.count ? self.addToCartBtn.enable() : self.addToCartBtn.disable()
        }
    }
    
    private func setupData() {
        self.menuItemImage.sd_setImage(with: URL.init(string: model?.imageUri ?? ""))
        self.itemNamelabel.text = model?.name
        self.itemDescLabel.text = model?.description
        self.itemPriceLabel.text = "$" + (model?.price ?? 0).withDecimal(2)
//        self.initialQuantity = 1
        self.itemLeftView.isHidden = (model?.remainingItems == 0 || model?.remainingItems == nil)
        self.itemLeft.text = "Only \(model?.remainingItems ?? 0) left"
        if model?.remainingItems != nil && model?.remainingItems == 0 {
            self.showToastMsg("This item is out of stock. Please schedule the order if you want to add this item.", state: .warning, location: .bottom)
        }
        //        model?.remainingItems != nil && model?.remainingItems == 0 ? self.addToCartBtn.disable() : self.addToCartBtn.enable()
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.start()
        }
        viewModel.itemModel.bind { model in
            self.model = model
            self.setupUpdateView()
            self.validateAddToCart()
        }
        viewModel.deleteState.bind { model in
            self.dismiss(animated: true) {
                self.didRemove?(self.selectedItem?.id)
            }
        }
        viewModel.cartList.bind { model in
            self.dismiss(animated: true) {
                self.didAddToCart?(self.selectedItem?.id)
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
            //            if isUpdate {
            //                cell.isUserInteractionEnabled = false
            //            }
            cell.model = model?.options?[indexPath.section].choices?[indexPath.row]
            
            cell.setup()
            cell.section = indexPath.section
            let b = self.selectedOptions.filter({$0.title == self.model?.options?[indexPath.section].title}).first
            let a = b?.choices?.map({$0.name ?? ""}) ?? []
            //            if isUpdate {
            cell.checkBox.isOn = a.contains(cell.model?.name ?? "")
            //            }
            cell.didSelect = { (val, section) in
                var check = MenuItemOptionsModel()
                //                let m = self.selectedOptions.filter({$0.multipleChoice == true}).first
                check.title = self.model?.options?[section].title
                check.multipleChoice = true
                let option = self.selectedOptions.filter({$0.title == check.title}).first
                self.selectedOptions = self.selectedOptions.filter({$0.title != check.title})
                var choices = option?.choices ?? []
                choices.append(val ?? ChoicesModel())
                check.choices = choices
                
                //                check.choices = m == nil ? [val ?? ChoicesModel()] : [val ?? ChoicesModel(), m?.choices?.filter({$0.name != val?.name}).first ?? ChoicesModel()]
                //                    self.selectedOptions = self.selectedOptions.filter({$0.multipleChoice != true})
                self.selectedOptions.append(check)
            }
            cell.didDeSelect = { (val, section) in
                guard var check = self.selectedOptions.filter({$0.title == self.model?.options?[section].title}).first else {return}
                check.choices = check.choices?.filter({$0.name != val})
                if check.choices?.isEmpty ?? false {
                    self.selectedOptions = self.selectedOptions.filter({$0.title != check.title})
                } else {
                    self.selectedOptions = self.selectedOptions.filter({$0.title != check.title})
                    self.selectedOptions.append(check)
                }
//                if check.choices?.count == 2 {
//                    var m = self.selectedOptions.filter({$0.multipleChoice != true})
//                    check.choices = check.choices?.filter({$0.name != val})
//                    m.append(check)
//                    self.selectedOptions = m
//                } else {
//                    self.selectedOptions = self.selectedOptions.filter({$0.multipleChoice != true})
//                }
//                //                self.selectedOptions.insert(check, at: section)
//                //                if choices.isEmpty == true {
//                //                    self.selectedOptions.remove(at: section)
//                //                }
            }
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChefMenuOptionRadioTableViewCell") as! ChefMenuOptionRadioTableViewCell
            //            if isUpdate {
            //                cell.isUserInteractionEnabled = false
            //            }
            cell.model = model?.options?[indexPath.section].choices?[indexPath.row]
            cell.section = indexPath.section
            cell.row = indexPath.row
            cell.setup()
            if self.selectedOptions.map({($0.choices?.first?.name ?? "", $0.title ?? "")}).contains(where: { a in
                return (a.0 == cell.model?.name) && a.1 == self.model?.options?[indexPath.section].title
            })  {
                cell.radioButton.isOn = true
            } else {
                cell.radioButton.isOn = false
            }
//            cell.radioButton.isOn = cell.optionName.text == selectedOption?.0
//            if isUpdate {
            
//            }
            cell.didSelect = { (val,section,row) in
                self.selectedOptions = self.selectedOptions.filter({self.model?.options?[section].title != $0.title})
                var check = MenuItemOptionsModel()
                check.title = self.model?.options?[section].title
                check.multipleChoice = self.model?.options?[section].multipleChoice
                check.choices = [val ?? ChoicesModel()]
                self.selectedOptions.append(check)
                self.tableView.reloadRows(at: (0...((self.model?.options?[section].choices?.count ?? 0) - 1)).map({IndexPath.init(row: $0, section: section)}), with: .none)
                
                //                self.selectedOption = (val?.name ?? "", section)
                //                if self.selectedOptions.isEmpty == true || section > (self.selectedOptions.count - 1) {
                //                    var check = MenuItemOptionsModel()
                //                    check.title = self.model?.options?[indexPath.section].title
//                    check.multipleChoice = self.model?.options?[indexPath.section].multipleChoice
//                    check.choices = [val ?? ChoicesModel()]
//                    self.selectedOptions.append(check)
//                } else if section <= (self.selectedOptions.count - 1) {
//                    var check = self.selectedOptions[section]
//                    check.choices = [val ?? ChoicesModel()]
//                    self.selectedOptions.remove(at: section)
//                    self.selectedOptions.insert(check, at: section)
//                }
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

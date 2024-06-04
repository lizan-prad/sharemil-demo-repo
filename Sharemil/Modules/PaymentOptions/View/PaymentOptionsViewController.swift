//
//  PaymentOptionsViewController.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import UIKit
import Stripe
import Alamofire
import PassKit

class PaymentOptionsViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCardView: UIView!
    var viewModel: PaymentOptionsViewModel!
    var model: PaymentIntentModel?
    var cartId: String?
    
    var models: [PaymentMethods]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var didSelectMethod: ((PaymentMethods?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTable()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getPaymentMethods()
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "PaymentOptionsListTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentOptionsListTableViewCell")
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.success.bind { msg in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.viewModel.getPaymentMethods()
                //                self.navigationController?.popViewController(animated: true)
            }
        }
        self.viewModel.methods.bind { models in
            if StripeAPI.deviceSupportsApplePay() {
                var m = models
                guard let p = PaymentMethods.init(JSON: ["name": "Apple Pay", "stripePaymentMethod" : ["card": ["brand" : "apple"]]]) else {return}
                
                m = m?.sorted(by: { a, b in
                    return a.isDefault ?? false
                })
                m?.insert( p, at: 0)
                self.models = m
            } else {
                self.models = models?.sorted(by: { a, b in
                    return a.isDefault ?? false
                })
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setup() {
        addCardView.isUserInteractionEnabled = true
        addCardView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:          #selector(openCardView)))
    }
    
    @objc private func openCardView() {
        guard let nav = self.navigationController else {return}
        let coordinator = CustomStripeCoordinator.init(navigationController: nav)
        coordinator.start()
    }
}

extension PaymentOptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionsListTableViewCell") as! PaymentOptionsListTableViewCell
        cell.model = self.models?[indexPath.row]
        cell.didSelectMenuAction = { id in
            let coordinator = PaymentEditOptionCoordinator.init(navigationController: UINavigationController.init())
            coordinator.id = id
            coordinator.didSelectDelete = { id in
                self.viewModel.deletePaymentMethod(id ?? "")
            }
            coordinator.didSelectDefault = { id in
                if id == nil {
                    self.viewModel.makeDefaultApplePay()
                } else {
                    self.viewModel.makeDefaultPaymentMethod(id ?? "")
                }
            }
            self.present(coordinator.getMainView(), animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectMethod?(self.models?[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

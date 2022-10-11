//
//  HelpItemIssueListViewController.swift
//  Sharemil
//
//  Created by Lizan on 11/10/2022.
//

import UIKit

class HelpItemIssueListViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableVie: UITableView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var smoke: UIView!
    
    var viewModel: HelpItemIssueViewModel!
    
    var category: String?
    
    var didSelectIssue: ((SupportIssues?) -> ())?
    
    var issueList: [SupportIssues]? {
        didSet {
            tableHeight.constant = CGFloat(issueList?.count ?? 0)*51
            self.tableVie.reloadData()
        }
    }
    
    var selectedModel: SupportIssues? {
        didSet {
            self.tableVie.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        bindViewModel()
        self.viewModel.getIssueList(category ?? "")
        
        self.container.addCornerRadius(10)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
    }
    
    private func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.4
                    
                }, completion: { _ in
                    
                })
    }
    
    @objc func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.0
                    
                }, completion: { _ in
                    self.dismiss(animated: true)
                })
        
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.issues.bind { list in
            self.issueList = list?.supportIssues
        }
    }
    
    private func setupTable() {
        tableVie.delegate = self
        tableVie.dataSource = self
        
        tableVie.register(UINib.init(nibName: "HelpItemIssueTableViewCell", bundle: nil), forCellReuseIdentifier: "HelpItemIssueTableViewCell")
    }

    @IBAction func submitAction(_ sender: Any) {
        self.dismissPopUp()
        self.didSelectIssue?(self.selectedModel)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismissPopUp()
    }
    
}

extension HelpItemIssueListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issueList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpItemIssueTableViewCell") as! HelpItemIssueTableViewCell
        cell.model = self.issueList?[indexPath.row]
        cell.setup()
        cell.issueRadio.isOn = cell.model?.id == self.selectedModel?.id
        cell.selectedModel = { model in
            self.selectedModel = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

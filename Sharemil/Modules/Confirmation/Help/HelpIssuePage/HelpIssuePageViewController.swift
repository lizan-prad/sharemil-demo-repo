//
//  HelpIssuePageViewController.swift
//  Sharemil
//
//  Created by Lizan on 05/10/2022.
//

import UIKit

struct IssueListStruct {
    var item: CartItems?
    var issue: SupportIssues?
}

class HelpIssuePageViewController: UIViewController, Storyboarded, UITextViewDelegate {

    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var cart: Cart?
    var orderId: String?
    
    var viewModel: HelpIssuePageViewModel!
    
    var issueList: [IssueListStruct]? {
        didSet {
            tableViewHeight.constant = CGFloat(issueList?.filter({$0.issue != nil}).count ?? 0)*90 + CGFloat(issueList?.filter({$0.issue == nil}).count ?? 0)*53
            self.validate()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please describe in details (Optional)"
            textView.textColor = UIColor.lightGray
        }
    }

    private func setup() {
        validate()
        detailsTextView.text = "Please describe in details (Optional)"
        detailsTextView.textColor = UIColor.lightGray
        self.detailsTextView.delegate = self
        self.detailsTextView.textContainer.lineFragmentPadding = 16
        self.detailsTextView.addCornerRadius(16)
        self.issueList = cart?.cartItems?.map({IssueListStruct.init(item: $0, issue: nil)})
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.issues.bind { msg in
            self.showToastMsg(msg ?? "", state: .success, location: .bottom)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.dismiss(animated: true) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validate()
    }
    
    private func validate() {
        (self.detailsTextView.text != "Please describe in details (Optional)" || self.detailsTextView.text != "") && (self.issueList?.filter({$0.issue != nil}).count != 0) ? continueBtn.enable() : continueBtn.disable()
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "HelpIssueFoodListTableViewCell", bundle: nil), forCellReuseIdentifier: "HelpIssueFoodListTableViewCell")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        viewModel.createSupportTicket(SupportTicketStruct.init(issues: issueList, orderNo: orderId ?? "", note: detailsTextView.text))
    }
}

extension HelpIssuePageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpIssueFoodListTableViewCell") as! HelpIssueFoodListTableViewCell
        cell.menuItem = issueList?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinator = HelpItemIssueListCoordinator.init(navigationController: UINavigationController())
        coordinator.categoryType = "item_quality"
        coordinator.didSelectIssue = { issue in
            self.issueList?.remove(at: indexPath.row)
            self.issueList?.insert(IssueListStruct.init(item: self.cart?.cartItems?[indexPath.row], issue: issue), at: indexPath.row)
        }
        self.present(coordinator.getMainView(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return issueList?[indexPath.row].issue == nil ? 53 : 90
    }
}

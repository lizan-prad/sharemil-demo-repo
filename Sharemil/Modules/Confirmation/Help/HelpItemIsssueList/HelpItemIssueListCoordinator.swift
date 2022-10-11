//
//  HelpItemIssueListCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 12/10/2022.
//

import UIKit

class HelpItemIssueListCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var didSelectIssue: ((SupportIssues?) -> ())?
    
    var categoryType: String?
    
    func getMainView() -> HelpItemIssueListViewController {
        let vc = HelpItemIssueListViewController.instantiate()
        vc.category = categoryType
        vc.viewModel = HelpItemIssueViewModel()
        vc.didSelectIssue = self.didSelectIssue
        return vc
    }
    
    func start() {
        
    }

    
}

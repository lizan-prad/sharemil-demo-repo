//
//  Coordinator.swift
//  Sharemil
//
//  Created by Lizan on 08/06/2022.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

protocol Storyboarded {
    static func instantiate() -> Self
}

//MARK: The storyboard name should be the same as the viewcontroller initials
extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        
        let fullName = NSStringFromClass(self)

        let className = fullName.components(separatedBy: ".")[1]

        let storyboard = UIStoryboard(name: className.replacingOccurrences(of: "ViewController", with: ""), bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
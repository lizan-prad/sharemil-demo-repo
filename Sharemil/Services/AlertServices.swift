//
//  AlertServices.swift
//  Sharemil
//
//  Created by Lizan on 13/06/2021.
//
import Foundation
import UIKit

class AlertServices {
    typealias CompletionHandler = ((UIAlertAction) -> Void)?
    
    static func showAlertWithOkAction(title: String?, message: String?, completion: CompletionHandler) -> UIAlertController {
        let alertAction = UIAlertAction.init(title: "Ok", style: .default, handler: completion)
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(alertAction)
        return alert
    }
    
    static func showAlertWithOkCancelAction(title: String?, message: String?, completion: CompletionHandler) -> UIAlertController {
        let alertAction = UIAlertAction.init(title: "Ok", style: .destructive, handler: completion)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    static func showAlertWithOkCancelActionCompletion(title: String?, message: String?, okCompletion: CompletionHandler, cancelCompletion: CompletionHandler) -> UIAlertController {
        let alertAction = UIAlertAction.init(title: "Ok", style: .destructive, handler: okCompletion)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: cancelCompletion)
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    static func showAlertWithOkCancelActionCompletionYes(title: String?, message: String?, okCompletion: CompletionHandler, cancelCompletion: CompletionHandler) -> UIAlertController {
        let alertAction = UIAlertAction.init(title: "Yes", style: .destructive, handler: okCompletion)
        let cancelAction = UIAlertAction.init(title: "No", style: .default, handler: cancelCompletion)
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        return alert
    }
}

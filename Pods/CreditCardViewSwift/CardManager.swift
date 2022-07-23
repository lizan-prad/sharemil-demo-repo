//
//  CardManager.swift
//  Sharemil
//
//  Created by Lizan on 21/07/2022.
//

import Foundation

class CardManager {
    
    static func getCardType(_ cardNo: String) -> String {
        if "\(cardNo.prefix(1))" == "4" {
            return "visa"
        } else if "\(cardNo.prefix(2))" == "51" || "\(cardNo.prefix(2))" == "55"  {
            return "mastercard"
        } else if "\(cardNo.prefix(2))" == "34" || "\(cardNo.prefix(2))" == "37" {
            return "american-express"
        } else if "\(cardNo.prefix(3))" == "305" || "\(cardNo.prefix(2))" == "36" || "\(cardNo.prefix(2))" == "38" {
            return "diners-club"
        } else if "\(cardNo.prefix(4))" == "6011" || "\(cardNo.prefix(2))" == "65" {
            return "discover"
        } else if "\(cardNo.prefix(4))" == "2131" || "\(cardNo.prefix(4))" == "1800" || "\(cardNo.prefix(2))" == "35" {
            return "jcb"
        } else {
            return "nil"
        }
    }
}

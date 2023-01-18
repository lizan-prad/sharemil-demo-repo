//
//  PickUpViewModel.swift
//  Sharemil
//
//  Created by Lizan on 18/01/2023.
//

import Foundation

class PickUpViewModel {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var orders: Observable<[OrderModel]> = Observable([])
}

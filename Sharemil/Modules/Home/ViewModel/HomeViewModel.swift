//
//  HomeViewModel.swift
//  Sharemil
//
//  Created by lizan on 13/06/2022.
//

import Foundation

class HomeViewModel: HomeService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    
    func fetchChefBy(location: LLocation, name: String?) {
        self.fetchChefs(location, with: name)
    }
}

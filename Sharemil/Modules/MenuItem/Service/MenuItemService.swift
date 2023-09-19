//
//  MenuItemService.swift
//  Sharemil
//
//  Created by lizan on 22/06/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol MenuItemService {
    func fetchChefMenuItem(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, NSError>) -> ())
    func fetchRecommendedItem(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, NSError>) -> ())
    func addToCart(_ chefId: String, itemId: String, quantity: Int, options: [MenuItemOptionsModel]?, completion: @escaping (Result<BaseMappableModel<CartListModel>, NSError>) -> ())
    func updateCart(_ chefId: String, cartItems: [CartItems], completion: @escaping (Result<BaseMappableModel<CartListModel>, NSError>) -> ())
}

extension MenuItemService {
    
    func fetchRecommendedItem(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<ChefMenuContainerModel>.self, urlExt: "carts/\(id)/recommended", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func fetchChefMenuItem(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<ChefMenuContainerModel>.self, urlExt: "menus/\(id)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func addToCart(_ chefId: String, itemId: String, quantity: Int, options: [MenuItemOptionsModel]?, completion: @escaping (Result<BaseMappableModel<CartListModel>, NSError>) -> ()) {
        
        let param: [String: Any] = [
            "chefId": chefId,
            "items": [
                self.getItemParam(id: itemId, options: options, quantity: quantity)
            ]
        ]
        
        NetworkManager.shared.request(BaseMappableModel<CartListModel>.self, urlExt: "carts", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    private func getItemParam(id: String, options: [MenuItemOptionsModel]?, quantity: Int) -> [String: Any] {
        return ["id": id,
                "quantity": quantity,
                "options": options?.map({getParam(option: $0)}) ?? []]
    }
    
    private func getParam(option: MenuItemOptionsModel) -> [String: Any] {
        return ["title": option.title ?? "",
                "choices:": option.choices?.map({self.getChoices(option: $0)}) ?? [],
                "multipleChoice": option.multipleChoice ?? false]
    }
    
    private func getChoices(option: ChoicesModel?) -> [String: Any] {
        return ["name": option?.name ?? "",
                "price:": option?.price ?? 0,
                "quantity": option?.quantity ?? 0]
    }
    
    func updateCartWith(_ date: String, _ time: String, _ chefId: String, cartItems: [CartItems], completion: @escaping (Result<BaseMappableModel<CartListModel>, NSError>) -> ()) {
        let param: [String: Any] = [
            "chefId": chefId,
            "items":
                cartItems.map({getItemParam(id: $0.menuItemId ?? "", options: $0.options, quantity: $0.quantity ?? 0)})
//            "pickupTime": [
//                    "date": date,
//                    "startTime": time
//                ]
            
        ]
        
        NetworkManager.shared.request(BaseMappableModel<CartListModel>.self, urlExt: "carts/\(cartItems.first?.cartId ?? "")", method: .put, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func updateCart(_ chefId: String, cartItems: [CartItems], completion: @escaping (Result<BaseMappableModel<CartListModel>, NSError>) -> ()) {
        let param: [String: Any] = [
            "chefId": chefId,
            "items":
                cartItems.map({getItemParam(id: $0.menuItemId ?? "", options: $0.options, quantity: $0.quantity ?? 0)})
//            "pickupTime": [String:Any]()
        ]
        
        NetworkManager.shared.request(BaseMappableModel<CartListModel>.self, urlExt: "carts/\(cartItems.first?.cartId ?? "")", method: .put, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}


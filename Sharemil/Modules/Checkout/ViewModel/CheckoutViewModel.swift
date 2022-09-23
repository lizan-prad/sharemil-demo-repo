//
//  CheckoutViewModel.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps

class CheckoutViewModel: CheckoutService, ChefMenuService, PaymentOptionsService, MenuItemService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var polylines: Observable<[GMSPath]> = Observable([])
    var cartList: Observable<Cart> = Observable(nil)
    var payment: Observable<PaymentIntentModel> = Observable(nil)
    var paymentIntent: Observable<CreatePaymentModel> = Observable(nil)
    var completeCheckout: Observable<OrderModel> = Observable(nil)
    
    func getRoute(_ origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        loading.value = true
        self.getRoutes(origin, destination: destination) { routes in
            self.loading.value = false
            var poly = [GMSPath]()
            for route in routes
            {
                if let path = GMSPath.init(fromEncodedPath: route.overview_polyline?.points ?? "") {
                    poly.append(path)
                }
            }
            self.polylines.value = poly
        }
    }
    
    func getCart(_ id: String) {
        self.fetchCartList(id) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.cartList.value = model.data?.cart
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func updateToCartWith(date: String,_ chefId: String, cartModels: [CartItems]) {
        self.loading.value = true
        self.updateCartWith(date.components(separatedBy: " ").first ?? "", date.components(separatedBy: " ").last ?? "", chefId, cartItems: cartModels) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.cartList.value = model.data?.cart
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func updateToCart(_ chefId: String, cartModels: [CartItems]) {
        self.loading.value = true
        self.updateCart(chefId, cartItems: cartModels) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.cartList.value = model.data?.cart
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func createPayment(_ cartId: String, paymentMethodId: String) {
        self.loading.value = true
        self.createPaymentIntent(cartId, paymentMethodId: paymentMethodId, completion: { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.paymentIntent.value = model.data
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        })
    }
    
    func continuePayment(_ paymentIntentId: String) {
        self.loading.value = true
        self.confirmPaymentIntent(paymentIntentId) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.completeCheckout.value = model.data?.orders
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    
    
    func proceedPayment(_ cartId: String) {
        self.loading.value = true
        self.paymentIntent(cartId) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.payment.value = model
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}

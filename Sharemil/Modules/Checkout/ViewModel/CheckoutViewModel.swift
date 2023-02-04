//
//  CheckoutViewModel.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps

class CheckoutViewModel: CheckoutService, ChefMenuService, PaymentOptionsService, MenuItemService, CustomStripeService, HomeService, AccountService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var success: Observable<String> = Observable(nil)
    var polylines: Observable<[GMSPath]> = Observable([])
    var cartList: Observable<Cart> = Observable(nil)
    var payment: Observable<PaymentIntentModel> = Observable(nil)
    var paymentIntent: Observable<CreatePaymentModel> = Observable(nil)
    var completeCheckout: Observable<OrderModel> = Observable(nil)
    var orderCreated: Observable<OrderModel> = Observable(nil)
    var method: Observable<PaymentMethods> = Observable(nil)
    var cusines: Observable<[CusineListModel]> = Observable([])
    var chefs: Observable<[ChefListModel]> = Observable([])
    var refresh: Observable<String> = Observable(nil)
    var user: Observable<UserModel> = Observable(nil)
    
    func fetchUserProfile() {
        self.loading.value = true
        self.fetchProfile { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.user.value = model.data?.user
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func fetchChefBy(location: LLocation, name: String?) {
        self.loading.value = true
        self.fetchChefs(location, with: name) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.cusines.value = model.data?.cuisines
                self.chefs.value = model.data?.chefs
            case .failure(let error):
                if error.code == 401 {
                    self.refresh.value = error.localizedDescription
                } else {
                    self.error.value = error.localizedDescription
                }
            }
        }
    }
    
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
    
    func getDefaultMethod() {
        self.loading.value = true
        self.getPaymentMethods { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.method.value = model.data?.paymentMethods?.filter({$0.isDefault ?? false}).first
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
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
                self.success.value = model.status
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
                self.success.value = model.status
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func createPayment(_ cartId: String, paymentMethodId: String, _ orderId: String) {
        self.loading.value = true
        self.createPaymentIntent(.card, cartId, paymentMethodId: paymentMethodId, orderId, completion: { result in
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
    
    func createOrderWith(_ pickUpDate: String?, _ paymentMethodId: String, _ cartId: String) {
        self.loading.value = true
        self.createOrder(pickUpDate, paymentMethodId, cartId) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.orderCreated.value = model.data?.orders
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

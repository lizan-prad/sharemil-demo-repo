//
//  NetworkManager.swift
//  Sharemil
//
//  Created by Lizan on 13/06/2022.
//

import UIKit
import ObjectMapper
import Alamofire
import SwiftyJSON
import FirebaseAuth
class NetworkManager {
    
    static let shared = NetworkManager()
    
    typealias CompletionHandler<T: Mappable> = (Result<T, NSError>) -> ()
    
    func request<T: Mappable>(_ value: T.Type ,urlExt: String, method: HTTPMethod, param: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping CompletionHandler<T>){
        
        let header = headers == nil ? [.authorization(bearerToken: UserDefaults.standard.string(forKey: StringConstants.userIDToken) ?? "")] : headers
        print(header)
        
        AF.request(URLConfig.baseUrl + urlExt, method: method, parameters: param, encoding: encoding, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                if let data = data as? [String:Any], let model = Mapper<T>().map(JSON: data) {
                    print(data)
                    if (400 ... 405).contains(response.response?.statusCode ?? 0) {
                        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { token, error in
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                                UserDefaults.standard.set(token, forKey: StringConstants.userIDToken)
                                NetworkManager.shared.request(value, urlExt: urlExt, method: method, param: param, encoding: encoding, headers: headers, completion: completion)
                            }
                        })
                    } else {
                        completion(.success(model))
                    }
                }
            case .failure(let error):
                print(String(describing: error))
                completion(.failure(NSError.init(domain: "login", code: response.response?.statusCode ?? 0, userInfo:   [NSLocalizedDescriptionKey: error.localizedDescription]  )))
            }
        }
    }
    
    func requestData(urlExt: String, method: HTTPMethod, param: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping (Data) -> ()){
        
        let header = headers == nil ? ["Accept" : "application/json", "Authorization":  "Bearer \(UserDefaults.standard.string(forKey: "AT") ?? "")"] : headers

        AF.request(urlExt, method: method, parameters: param, encoding: encoding, headers: header).responseData { data in
            if let data = data.data {
                completion(data)
            }
        }
    }
    
    func requestMultipart<T: Mappable>(_value: T.Type, param:[String: Any],arrImage:[UIImage],imageKey:String,URlName:String,controller:UIViewController, withblock:@escaping (_ response: AnyObject?)->Void){

        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data", "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "AT") ?? "")"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for img in arrImage {
                guard let imgData = img.jpegData(compressionQuality: 1) else { return }
                multipartFormData.append(imgData, withName: imageKey, fileName: "\(Date().timeIntervalSince1970)" + ".jpeg", mimeType: "image/jpeg")
            }
            
            
        },to: URL.init(string: URLConfig.baseUrl + URlName)!, usingThreshold: UInt64.init(),
          method: .post,
          headers: headers).response{ response in
            
            if((response.error != nil)){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        
                        let status = parsedData["responseStatus"] as? NSInteger ?? 0
                        
                        if (status == 1){
                            if let model = Mapper<T>().map(JSONObject: parsedData) {
                                print(model)
                            }
                            
                        }else if (status == 2){
                            print("error message")
                        }else{
                            print("error message")
                        }
                    }
                }catch{
                    print("error message")
                }
            }else{
                 print(response.error!.localizedDescription)
            }
        }
    }
       
}

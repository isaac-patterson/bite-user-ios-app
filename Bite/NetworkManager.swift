//
//  NetworkManager.swift
//  Currency Converter
//
//  Created by Amit Shukla on 22/12/17.
//  Copyright © 2017 Amit Shukla. All rights reserved.
//

import Foundation
import Alamofire
import SwiftUI

let DEBUG = true

protocol ProgressChanges
{
    func progress(val: Float)
}

class SSFiles {
    var url:URL?
    var image:UIImage?
    var name: String = "File"
    var oldUrl: String?
    
    init(url:URL) {
        self.url = url
        name = (url.absoluteString as NSString).lastPathComponent
    }
    
    init(image:UIImage) {
        self.image = image
        name = "image"
    }
    
    init(oldUrl: String) {
        self.oldUrl = oldUrl
    }
    
}
class NetworkManager {
    //https://biteapp.work/user/api/Restaurant
    
    static var delegate: ProgressChanges?
    
    static let PROTOCOL:String = "https://";
    static let SUB_DOMAIN:String =  "";
    
    static let DOMAIN:String = "biteapp.work/";//Production Service End
    
    static var languges:String = "en/"
    
    static let API_DIR:String = "user/api/";
    
    static let SITE_URL = PROTOCOL + SUB_DOMAIN + DOMAIN;
    static let API_URL = SITE_URL  + API_DIR;
    
    static let STORAGE_URL = SITE_URL + "storage/";
    
    static let PRIVACY_POLICY_URL = "\(DOMAIN)"
    static let TERMS_AND_CONDITIONS = "\(DOMAIN)"
    
    
    @ObservedObject var loginUserData = LoginUserModel.shared
    
    
    
    static func callService(url:String, parameters:Parameters, httpMethod:HTTPMethod = .post, completion:@escaping (NetworkResponseState) -> Void){
        let api_Url = API_URL + url
        var  tokenDict:HTTPHeaders = [:]
        //        if LoginUserModel.shared.isLogin {
        tokenDict = ["Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"]
        
        //		print("parms \(parameters)")
        Alamofire.request(api_Url, method:httpMethod, parameters:parameters, encoding: JSONEncoding.default,headers: tokenDict).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            //            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(String(describing: response.result.value))")                   // response serialization result
            
            
            guard response.result.isSuccess else {
                completion(.failed("Something went wrong!!"))
                print("Error while fetching json: \(String(describing: response.result.error))")
                return
            }
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion(.failed("Something went wrong!!"))
                print("invalid json recieved from server: \(String(describing: response.result.error))")
                return
            }
            
            if response.response?.statusCode == 200 {
                completion(.success(responseJSON) )
            }else{
                completion(.failed(response.result.error?.localizedDescription ?? "Something went wrong!!"))
            }
        }
    }
    static func callServicePut(url:String, parameters:Parameters, httpMethod:HTTPMethod = .put, completion:@escaping (NetworkResponseState) -> Void){
        let api_Url = API_URL + url
        var  tokenDict:HTTPHeaders = [:]

        tokenDict = ["Content-Type": "application/json","Authorization": "Token " ]
      
        //        print("parms \(parameters)")
        Alamofire.request(api_Url, method:httpMethod, parameters:parameters, encoding: JSONEncoding.default,headers: tokenDict).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            //            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(String(describing: response.result.value))")                   // response serialization result
            
            
            guard response.result.isSuccess else {
                completion(.failed("Something went wrong!!"))
                print("Error while fetching json: \(String(describing: response.result.error))")
                return
            }
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion(.failed("Something went wrong!!"))
                print("invalid json recieved from server: \(String(describing: response.result.error))")
                return
            }
            
            if response.response?.statusCode == 200 {
                completion(.success(responseJSON) )
            }else{
                completion(.failed("Something went wrong!!"))
            }
        }
    }
    
    static func callServiceForResetPassword(url:String, parameters:Parameters, token : String,httpMethod:HTTPMethod = .post, completion:@escaping (NetworkResponseState) -> Void){
        let api_Url = API_URL + url
        var  tokenDict:HTTPHeaders = [:]
        
        
        tokenDict = ["Content-Type": "application/json","Authorization": "Token \(token)" ]
        
        
        //        print("parms \(parameters)")
        Alamofire.request(api_Url, method:httpMethod, parameters:parameters, encoding: JSONEncoding.default,headers: tokenDict).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(String(describing: response.result.value))")                   // response serialization result
            
            
            guard response.result.isSuccess else {
                completion(.failed("Something went wrong!!"))
                print("Error while fetching json: \(String(describing: response.result.error))")
                return
            }
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion(.failed("Something went wrong!!"))
                print("invalid json recieved from server: \(String(describing: response.result.error))")
                return
            }
            
            if response.response?.statusCode == 200 {
                completion(.success(responseJSON) )
            }else{
                completion(.failed("Something went wrong!!"))
            }
        }
    }
    
    
    static func callServiceLogin(url:String, parameters:Parameters, completion: @escaping (NetworkResponseState) -> Void){
        let api_Url = API_URL + url
        let TokenDict = ["Content-Type": "application/json","APP-TYPE" : "worker_app"]
        
        Alamofire.request(api_Url, method:.post, parameters:parameters, encoding: JSONEncoding.default, headers: TokenDict).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(String(describing: response.result.value))")                         // response serialization result
            
            
            guard response.result.isSuccess else {
                completion(.failed("Something went wrong!!"))
                print("Error while fetching json: \(String(describing: response.result.error))")
                return
            }
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion(.failed("Something went wrong!!"))
                print("invalid json recieved from server: \(String(describing: response.result.error))")
                return
            }
            
            if response.response?.statusCode == 200 {
                completion(.success(responseJSON) )
            }else{
                completion(.failed("Something went wrong!!"))
            }
        }
    }
    
    static func callServiceMultipalFiles(url:String, files:[SSFiles], parameters:Parameters, completion: @escaping (NetworkResponseState) -> Void){
        
        var  tokenDict:HTTPHeaders = [:]

            tokenDict = ["Content-Type": "application/json","Authorization": "Token " ]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                var count = 0
                for item in files {
                    if let fileUrl = item.url {
                        do {
                            let data = try Data(contentsOf: fileUrl )
                            multipartFormData.append(data, withName: "post_file[\(count)]",fileName: (fileUrl.absoluteString as NSString).lastPathComponent, mimeType: "application/octet-stream")
                            count = count + 1
                        } catch let error{
                            print(error)
                        }
                    } else if let image = item.image {
                        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                            print("Could not get JPEG representation of UIImage")
                            return
                            
                        }
                        multipartFormData.append(imageData, withName: "post_file[\(count)]",fileName:"\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                        count = count + 1
                    } else if let oldImage: String = item.oldUrl {
                        multipartFormData.append((oldImage as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "post_file[\(count)]")
                        
                        count = count + 1
                    }
                }
                
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        }, to:  url, headers: tokenDict) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Request: \(String(describing: response.request))")   // original url request
                    //print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(String(describing: response.result.value))")                         // response serialization result
                    
                    
                    guard response.result.isSuccess else {
                        completion(.failed("Something went wrong!!"))
                        print("Error while fetching json: \(String(describing: response.result.error))")
                        return
                    }
                    guard let responseJSON = response.result.value as? [String: Any] else {
                        completion(.failed("Something went wrong!!"))
                        print("invalid json recieved from server: \(String(describing: response.result.error))")
                        return
                    }
                    
                    if response.response?.statusCode == 200 {
                        completion(.success(responseJSON) )
                    }else{
                        completion(.failed("Something went wrong!!"))
                    }
                }
            case .failure(_):
                completion(.failed("Something went wrong!!"))
            }
        }
    }
    static func callService(url:String, file:URL?, image:UIImage?, completion:@escaping (NetworkResponseState) -> Void){
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if let file:URL = file {
                    do {
                        let data = try Data(contentsOf: file )
                        multipartFormData.append(data, withName: "file", fileName: (file.absoluteString as NSString).lastPathComponent, mimeType: "application/octet-stream")
                        
                    } catch let error{
                        print(error)
                    }
                }
                if let item:UIImage = image {
                    
                    guard let imageData = item.jpegData(compressionQuality: 1.0) else {
                        print("Could not get JPEG representation of UIImage")
                        return
                        
                    }
                    multipartFormData.append(imageData, withName: "file", fileName:"photoasdscac.jpg" ,mimeType: "image/jpg")
                }
                
                
        }, to:  url) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Request: \(String(describing: response.request))")   // original url request
                    //print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(String(describing: response.result.value))") // response serialization result
                    
                    
                    guard response.result.isSuccess else {
                        completion(.failed("Something went wrong!!"))
                        print("Error while fetching json: \(String(describing: response.result.error))")
                        return
                    }
                    guard let responseJSON = response.result.value as? [String: Any] else {
                        completion(.failed("Something went wrong!!"))
                        print("invalid json recieved from server: \(String(describing: response.result.error))")
                        return
                    }
                    
                    if response.response?.statusCode == 200 {
                        completion(.success(responseJSON) )
                    }else{
                        completion(.failed("Something went wrong!!"))
                    }
                }
            case .failure(_):
                completion(.failed("Something went wrong!!"))
            }
        }
    }
    
    static func callServiceUpdate(url:String,imgKey : String, parameters:Parameters, file:UIImage,imgesData:Array<Data>,imagesDict : [String : UIImage],method:HTTPMethod, completion:@escaping (NetworkResponseState) -> Void){
        let api_Url = API_URL + url
        _ = 0
        
        var  tokenDict:HTTPHeaders = [:]
            tokenDict = ["Content-Type": "application/json","Authorization": "Token " ]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //                if let item:Array = imgesData {
                //                    for index in imgesData  {
                //
                //                        multipartFormData.append(index, withName: "documents[certificates]",fileName:"photo.jpg" ,mimeType: "image/jpg")
                //                        counter = counter+1
                //                    }
                //                }
//                if let item:[String:UIImage] = imagesDict {
                    
                    for (key,value) in imagesDict {
                        
                        let imageData = value.jpegData(compressionQuality: 1.0)
                        
                        if value.size.width != 0  {
                            print("key of image................", key)
                            multipartFormData.append(imageData!, withName: key, fileName:"photo.jpg" ,mimeType: "image/jpg")
                        }
                    }
                //}
                
                for (key, value) in parameters {
                    print("key is sendinggggggggggggg=============================================", key)
                    if  (value as AnyObject).isKind(of: NSArray.self)
                    {
                        let arrayObj = value as! NSArray
                        let count : Int  = arrayObj.count
                        
                        for i in 0  ..< count
                        {
                            let value = arrayObj[i] as! String
                            let valueObj = value
                            _ = key + "[" + String(i) + "]"
                            multipartFormData.append(valueObj.data(using: String.Encoding.utf8)!, withName: key)
                        }
                        
                    }
                    else{
                        var valueStr = String()
                        if let param = value as? String{
                            valueStr = param
                        }else{
                            let valueInt = value as! Int
                            valueStr = String(valueInt)
                        }
                        
                        multipartFormData.append((valueStr).data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                    
                }
        }, to:  api_Url, method: method, headers:tokenDict) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress.fractionCompleted * 100)
                    delegate?.progress(val: Float(progress.fractionCompleted))
                })
                
                upload.responseJSON { response in
                    
                    print("Request: \(String(describing: response.request))")   // original url request
                    //print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(String(describing: response.result.value))")                         // response serialization result
                    
                    guard response.result.isSuccess else {
                        completion(.failed("Something went wrong!!"))
                        print("Error while fetching json: \(String(describing: response.result.error))")
                        return
                    }
                    guard let responseJSON = response.result.value as? [String: Any] else {
                        completion(.failed("Something went wrong!!"))
                        print("invalid json recieved from server: \(String(describing: response.result.error))")
                        return
                    }
                    
                    if response.response?.statusCode == 200 {
                        completion(.success(responseJSON) )
                    }else{
                        completion(.failed("Something went wrong!!"))
                    }
                }
            case .failure(_):
                completion(.failed("Something went wrong!!"))
            }
        }
    }
    
    static func callServicePhotoUpLoad(url:String,imgKey : String, parameters:Parameters,imagesDict : [UIImage] ,method:HTTPMethod, completion:@escaping (NetworkResponseState) -> Void){
        let api_Url = API_URL + url
        _ = 0
        
        var  tokenDict:HTTPHeaders = [:]
            tokenDict = ["Content-Type": "application/json","Authorization": "Token " ]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //                if let item:Array = imgesData {
                //                    for index in imgesData  {
                //
                //                        multipartFormData.append(index, withName: "documents[certificates]",fileName:"photo.jpg" ,mimeType: "image/jpg")
                //                        counter = counter+1
                //                    }
                //                }
//                if let item:[UIImage] = imagesDict {
                    
                    for i in imagesDict {
                        
                        let imageData = i.jpegData(compressionQuality: 1.0)
                        
                        if i.size.width != 0  {
                            
                            multipartFormData.append(imageData!, withName: imgKey, fileName:"photo.jpg" ,mimeType: "image/jpg")
                        }
                    }
                //}
                
                for (key, value) in parameters {
                    print("key is sendinggggggggggggg=============================================", key)
                    if  (value as AnyObject).isKind(of: NSArray.self)
                    {
                        let arrayObj = value as! NSArray
                        let count : Int  = arrayObj.count
                        
                        for i in 0  ..< count
                        {
                            let value = arrayObj[i] as! String
                            let valueObj = value
                            _ = key + "[" + String(i) + "]"
                            multipartFormData.append(valueObj.data(using: String.Encoding.utf8)!, withName: key)
                        }
                        
                    }
                    else{
                        var valueStr = String()
                        if let param = value as? String{
                            valueStr = param
                        }else{
                            let valueInt = value as! Int
                            valueStr = String(valueInt)
                        }
                        
                        multipartFormData.append((valueStr).data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                    
                }
        }, to:  api_Url, method: method, headers:tokenDict) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress.fractionCompleted * 100)
                    delegate?.progress(val: Float(progress.fractionCompleted))
                })
                
                upload.responseJSON { response in
                    print("Request: \(String(describing: response.request))")   // original url request
                    //print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(String(describing: response.result.value))")                         // response serialization result
                    
                    
                    guard response.result.isSuccess else {
                        completion(.failed("Something went wrong!!"))
                        print("Error while fetching json: \(String(describing: response.result.error))")
                        return
                    }
                    guard let responseJSON = response.result.value as? [String: Any] else {
                        completion(.failed("Something went wrong!!"))
                        print("invalid json recieved from server: \(String(describing: response.result.error))")
                        return
                    }
                    
                    if response.response?.statusCode == 200 {
                        completion(.success(responseJSON) )
                    }else{
                        completion(.failed("Something went wrong!!"))
                    }
                }
            case .failure(_):
                completion(.failed("Something went wrong!!"))
            }
        }
    }
    
    static func callService(url:String, completion:@escaping (Any?) -> Void){
        let api_Url = API_URL + url
        var tokenDict:HTTPHeaders = [:]
        tokenDict = ["Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"]
        
        print(tokenDict)
        Alamofire.request(api_Url, method:.get, headers:tokenDict).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(String(describing: response.result.value))")                   // response serialization result
            
                     
            completion(response.result.value)
//            guard response.result.isSuccess else {
//                completion(.failed("Something went wrong!!"))
//                print("Error while fetching json: \(String(describing: response.result.error))")
//                return
//            }
//            guard let responseJSON = response.result.value as? [String: Any] else {
//                completion(.failed("Something went wrong!!"))
//                print("invalid json recieved from server: \(String(describing: response.result.error))")
//                return
//            }
//
//            if response.response?.statusCode == 200 {
//                completion(.success(responseJSON) )
//            }else if response.response?.statusCode == 401 {
//                //LoginUserModel.shared.logout()
//
//            }else{
//                completion(.failed("Something went wrong!!"))
//            }
        }
    }
    
    static func callServiceDelete(url:String, completion:@escaping (NetworkResponseState) -> Void){
        let api_Url = API_URL + url
        var tokenDict:HTTPHeaders = [:]
            tokenDict = ["Content-Type": "application/json", "Authorization": "Token" ]
        
        Alamofire.request(api_Url, method:.delete, headers:tokenDict).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(String(describing: response.result.value))")                   // response serialization result
            
            
            guard response.result.isSuccess else {
                completion(.failed("Something went wrong!!"))
                print("Error while fetching json: \(String(describing: response.result.error))")
                return
            }
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion(.failed("Something went wrong!!"))
                print("invalid json recieved from server: \(String(describing: response.result.error))")
                return
            }
            
            if response.response?.statusCode == 200 {
                completion(.success(responseJSON) )
            }else if response.response?.statusCode == 401 {
                //LoginUserModel.shared.logout()
                
            }else{
                completion(.failed("Something went wrong!!"))
            }
        }
    }
}
enum NetworkResponseState {
    case success([String:Any])
    case failed(String)
}
//MARK:- mange multiple storyboard instance
enum AppStoryboard : String {
    case Login = "Login"
    case Home = "Home"
    case Booking = "Booking"
    case UpdateProfile = "UpdateProfile"
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
    
}
extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

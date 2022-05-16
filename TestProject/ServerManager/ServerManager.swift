//
//  ServerManager.swift
//  TestProject
//
//  Created by dima on 16.05.2022.
//

import UIKit
import Alamofire

@objc class ServerManager: NSObject {
    @objc static let shared = ServerManager()
    fileprivate let timeOutTime = 30.0
    
    fileprivate override init() { }
    
    private var baseUrl: String {
        let urlString = "https://back.chichiko-and-co.com.ua" + "/api/" + "v" + "3" + "/user/"
        return urlString
    }
    
    private var authorization: String? {
//        let token = UserDefaultsService.takeAccessToken()
//        //        let tokenType = UserDefaultsService.takeTokenType()
//        guard token != nil else {
//            return nil
//        }
//        let authorization = "Bearer " + token!
//        return authorization
        return nil
    }
    
    func restaurants(completion: @escaping (IsSuccess,RestaurantsResult,RestaurantsValue?)->Void) {
        let request = "restaurants"
        
        let version = "1.2"// Constants.Server.apiVersion
//        guard  let authorization = self.authorization else {
//            completion(false, .unknownStatus, nil)
//            return
//        }
        let headers:HTTPHeaders = [/*"Authorization": authorization,*/ "api-version": version]
        
        makeRequest(request: request, method: .get, parameters: nil, headers: headers, invalidTokenStatusCode: RestaurantsResult.tokenInvalid.rawValue) { (isSuccess, responseCode, something) in
            
            if isSuccess && responseCode != nil {
                let restaurantsResult = RestaurantsResult(responseCode: responseCode!)
                let restaurantsValue = RestaurantsValue(something: something)
                if restaurantsResult == .success && restaurantsValue != nil {
                    LoadedDataManager.shared.setupRestaurants(restaurants: restaurantsValue!.restaurants)
                }
                completion(true, restaurantsResult, restaurantsValue)
            }
            else {
                completion(false, .unknownStatus, nil)
            }
        }
    }
    
    func comments(restaurantId: Int, completion: @escaping (IsSuccess,CommentsResult,CommentsValue?)->Void) {
        let request = "restaurant/comments/\(restaurantId)"
        
        let version = "1.2"// Constants.Server.apiVersion
//        guard  let authorization = self.authorization else {
//            completion(false, .unknownStatus, nil)
//            return
//        }
        let headers:HTTPHeaders = [/*"Authorization": authorization,*/ "api-version": version]
        
        makeRequest(request: request, method: .get, parameters: nil, headers: headers, invalidTokenStatusCode: CommentsResult.tokenInvalid.rawValue) { (isSuccess, responseCode, something) in
            
            if isSuccess && responseCode != nil {
                let commentsResult = CommentsResult(responseCode: responseCode!)
                let commentsValue = CommentsValue(something: something)
                completion(true, commentsResult, commentsValue)
            }
            else {
                completion(false, .unknownStatus, nil)
            }
        }
    }
    
    func news(restaurantId: Int, completion: @escaping (IsSuccess,NewsResult,NewsValue?)->Void) {
        let request = "restaurant/" + "\(restaurantId)" + "/news"
        let version = "1.2"//Constants.Server.apiVersion
//        guard  let authorization = self.authorization else {
//            completion(false, .unknownStatus, nil)
//            return
//        }
        
        let headers:HTTPHeaders = [/*"Authorization": authorization,*/ "api-version":version]
        
        makeRequest(request: request, method: .get, parameters: nil, headers: headers, invalidTokenStatusCode: NewsResult.tokenInvalid.rawValue) { (isSuccess, responseCode, something) in
            
            if isSuccess && responseCode != nil {
                let newsResult = NewsResult(responseCode: responseCode!)
                let newsValue = NewsValue(something: something)
                completion(true, newsResult, newsValue)
            }
            else {
                completion(false, .unknownStatus, nil)
            }
        }
    }
    
    fileprivate func makeRequest(request: String, method: HTTPMethod, parameters:[String: Any]?, headers:HTTPHeaders?, invalidTokenStatusCode: Int?, completion: @escaping (Bool, Int?, Any?)->Void) {
        let urlString = baseUrl + request
        print("urlString: ", urlString)
        print("method: ", method.rawValue)
        if parameters != nil {
            print("parameters: ", parameters!)
        }
        if headers != nil {
            print("parameters: ", headers!)
        }
        
        print(urlString)
        
        AF.request(urlString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).responseJSON { [weak self] (response) in
            
            print(response)
            //            print(response.something!)
            
            if response.error != nil {
                DispatchQueue.main.async {
                    completion(false, nil, nil)
                }
            }
            else {
                print("response.something: ", response.value ?? "")
                let something = response.value
                let statusCode = response.response?.statusCode
                print("response.response: ", response.response ?? "")
                if statusCode != nil {
                    if invalidTokenStatusCode != nil, statusCode! == invalidTokenStatusCode! {
//                        self?.refreshToken { (refreshTokenIsSuccess, refreshTokenResult, refreshTokenValue) in
//
//                            if refreshTokenIsSuccess == true, refreshTokenResult == .success, refreshTokenValue != nil {
//                                let accessToken = refreshTokenValue!.accessToken
//                                let refreshToken = refreshTokenValue!.refreshToken
//                                let tokenType = refreshTokenValue!.tokenType
//                                UserDefaultsService.setupTokens(accessToken: accessToken, refreshToken: refreshToken, tokenType: tokenType)
//
//                                guard  let authorization = self?.authorization else {
//                                    completion(false, nil, nil)
//                                    return
//                                }
//                                var headers1 = headers
//                                headers1?["Authorization"] = authorization
//
//                                self?.makeRequest(request: request, method: method, parameters: parameters, headers: headers1, invalidTokenStatusCode: nil, completion: { (isSuccess1, responseCode1, something) in
//                                    completion(isSuccess1, responseCode1, something)
//                                })
//                            }
//                            else {
//                                completion(false, statusCode, something)
//                            }
//                        }
                        
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(true, statusCode, something)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(true, nil, something)
                    }
                }
            }
        }
    }
}

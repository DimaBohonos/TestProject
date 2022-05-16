//
//  ServerManagerResult.swift
extension ServerManager {
    
    typealias IsSuccess = Bool
    
    enum RestaurantsResult: Int {
        case success = 200
        case tokenInvalid = 205
        case unknownStatus = 9999
        
        init(responseCode: Int) {
            let result = Self(rawValue: responseCode)
            self = result ?? .unknownStatus
        }
    }
    
    enum CommentsResult: Int {
        case success = 200
        case tokenInvalid = 205
        case unknownStatus = 9999
        
        init(responseCode: Int) {
            let result = Self(rawValue: responseCode)
            self = result ?? .unknownStatus
        }
    }
    
    enum NewsResult: Int {
        case success = 200
        case tokenInvalid = 205
        case unknownStatus = 9999
        
        init(responseCode: Int) {
            let result = Self(rawValue: responseCode)
            self = result ?? .unknownStatus
        }
    }
    
    struct CommentsValue {
        let comments:[Comment]
        
        init?(something:Any?) {
            let dict = something as? [String:Any]
            guard dict != nil else {
                return nil
            }
            
            let commentsDicts = dict!["comments"] as? [[String:Any]]
            
            guard commentsDicts != nil else {
                return nil
            }
            var comments1:[Comment] = []
            for commentDict in commentsDicts! {
                let comment = Comment(dict: commentDict)
                if comment != nil {
                    comments1.append(comment!)
                }
            }
            self.comments = comments1
        }
    }
    
    struct RestaurantsValue {
        let restaurants: [Restaurant]
        
        init?(something:Any?) {
            let dict = something as? [String:Any]
            guard dict != nil else {
                return nil
            }
            var allRestaurants: [Restaurant] = []
            let allRestaurantDicts = dict!["all"] as? [[String: Any]]
            if allRestaurantDicts != nil {
                var allRestaurants1:[Restaurant] = []
                for restaurantDict in allRestaurantDicts! {
                    let restaurant = Restaurant(dict: restaurantDict)
                    if restaurant != nil {
                        allRestaurants1.append(restaurant!)
                    }
                }
                allRestaurants = allRestaurants1
            }
            
            var newRestaurants: [Restaurant] = []
            let newRestaurantDicts = dict!["new"] as? [[String: Any]]
            if newRestaurantDicts != nil {
                var newRestaurants1:[Restaurant] = []
                for restaurantDict in newRestaurantDicts! {
                    let restaurant = Restaurant(dict: restaurantDict)
                    if restaurant != nil {
                        newRestaurants1.append(restaurant!)
                    }
                }
                newRestaurants = newRestaurants1
            }
            
            var topRatedRestaurants: [Restaurant] = []
            let topRatedRestaurantDicts = dict!["top_rated"] as? [[String: Any]]
            if topRatedRestaurantDicts != nil {
                var topRatedRestaurants1:[Restaurant] = []
                for restaurantDict in topRatedRestaurantDicts! {
                    let restaurant = Restaurant(dict: restaurantDict)
                    if restaurant != nil {
                        topRatedRestaurants1.append(restaurant!)
                    }
                }
                topRatedRestaurants = topRatedRestaurants1
            }
            restaurants = topRatedRestaurants + newRestaurants + allRestaurants
        }
    }
    
    struct NewsValue {
        let news: [News]
        
        init?(something:Any?) {
            let array = something as? [[String:Any]]
            guard array != nil else {
                return nil
            }
            
            var newArray: [News] = []
            for dict in array! {
                let news = News(dict: dict)
                if news != nil {
                    newArray.append(news!)
                }
            }
            self.news = newArray
        }
    }
    
}

//
//  LoadedDataManager.swift

import UIKit

class LoadedDataManager {
    static let shared = LoadedDataManager()
    fileprivate var restaurants: [Restaurant]?
//    fileprivate var user: User?
    
    fileprivate init() { }
    
    func takeRestaurant(restaurantId: Int) -> Restaurant? {
        guard restaurants != nil else {
            return nil
        }
        for restaurant in restaurants! {
            if restaurant.id == restaurantId {
                return restaurant
            }
        }
        return nil
    }
    
    func takeAllRestaurants() -> [Restaurant]? {
        return restaurants
    }
    
    func setupRestaurants(restaurants: [Restaurant]?) {
        self.restaurants = restaurants
    }
    
//    func takeUser() -> User? {
//        return user
//    }
//
//    func setupUser(user: User?) {
//        self.user = user
//    }
//
//    func takeUserPhoneNumber() -> String? {
//        let userPhoneNumber = self.user?.phone
//        return userPhoneNumber
//    }
}

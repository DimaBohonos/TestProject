//
//  DeliveryOrder.swift

import UIKit

struct DeliveryOrder {
    let address: String?
    let admin_id: Int?
//    let country: Country?
    let createdAt: Date?
    let date_from: Date?
    let date_to: Date?
//    let delivery: Delivery?
//    let foods: [DeliveryFood]?
    let guarantor_creator_status: String?
    let invitedUsers: Any?
    let latitude: Double?
    let longitude: Double?
    let main_order_id: Int?
    let isMenuIncluded: Bool?
    let menu_type: String?
    let order_history_type: String?
    let order_status: String?
    let order_type: String?
    let orders: Any?
    let restaurant_id: Int?
    let restaurant_name: String?
    let restaurant_photo: String?
    let updatedAt: Date?
    let user_comment: String?
    
    init?(dict: [String:Any]?) {
        guard let dict1 = dict else {
            return nil
        }
        
        let createdAtString = dict1["created_at"] as? String
        createdAt = ModelHelper.dateFromString(createdAtString)
        let updatedAtString = dict1["updated_at"] as? String
        updatedAt = ModelHelper.dateFromString(updatedAtString)
        
        let date_fromString = dict1["date_from"] as? String
        date_from = ModelHelper.dateFromString(date_fromString)
        let date_toString = dict1["date_to"] as? String
        date_to = ModelHelper.dateFromString(date_toString)
        
        address = dict1["address"] as? String
        admin_id = dict1["admin_id"] as? Int
//        let countryDict = dict1["country"] as? [String: Any]
//        country = Country(dict: countryDict)
//        let deliveryDict = dict1["delivery"] as? [String: Any]
//        delivery = Delivery(dict: deliveryDict)
//
//        let foodsDicts = dict1["foods"] as? [[String: Any]]
//        if foodsDicts != nil {
//            foods = foodsDicts!.compactMap({ (dict) -> DeliveryFood? in
//                let deliveryFood = DeliveryFood(dict: dict)
//                return deliveryFood
//            })
//        }
//        else {
//            foods = nil
//        }
        guarantor_creator_status = dict1["created_at"] as? String
        invitedUsers = dict1["invitedUsers"]
        latitude = dict1["lat"] as? Double
        longitude = dict1["lng"] as? Double
        main_order_id = dict1["main_order_id"] as? Int
        let isMenuIncludedInt = dict1["menu_included"] as? Int
        isMenuIncluded = ModelHelper.boolFromInt(isMenuIncludedInt)
        
        menu_type = dict1["menu_type"] as? String
        order_history_type = dict1["order_history_type"] as? String
        order_status = dict1["order_status"] as? String
        order_type = dict1["order_type"] as? String
        orders = dict1["orders"]
        restaurant_id = dict1["restaurant_id"] as? Int
        restaurant_name = dict1["restaurant_name"] as? String
        restaurant_photo = dict1["restaurant_photo"] as? String
        user_comment = dict1["user_comment"] as? String
    }
}

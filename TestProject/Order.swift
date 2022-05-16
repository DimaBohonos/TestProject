//
//  Order.swift

import UIKit

struct Order {
    let address: String?
    let adminId: Int?
    let country: [String: Any]?
    let createdAt: Date?
    let dateFrom: Date?
    let dateTo: Date?
    let guarantorCreatorStatus: String?
//    let invitedUsers: [InvitedUser]?
    let latitude: Double?
    let longitude: Double?
    let mainOrderId: Int?
    let isMenuIncluded: Bool?
    let menuType: String?
    let orderHistoryType: String?
    let orderStatus: String?
    let orderType: String?
    let orders: [[String: Any]]?
    let restaurantId: Int?
    let restaurantName: String?
    let restaurantPhoto: String?
    let updatedAt: Date?
    let userComment: String?
    
    let personName: String?
    let personPhone: String?
    let guestsCount: Int?
    
    init?(dict: [String:Any]?) {
        guard let dict1 = dict else {
            return nil
        }
        
        address = dict1["address"] as? String
        adminId = dict1["admin_id"] as? Int
        country = dict1["country"] as? [String: Any]
        let createdAtString = dict1["created_at"] as? String
        createdAt = ModelHelper.dateFromString(createdAtString)
        let dateFromString = dict1["date_from"] as? String
        dateFrom = ModelHelper.dateFromString(dateFromString)
        let dateToString = dict1["date_to"] as? String
        dateTo = ModelHelper.dateFromString(dateToString)
        guarantorCreatorStatus = dict1["guarantor_creator_status"] as? String
//        let invitedUsers1 = dict1["invitedUsers"] as? [[String: Any]]
//        if invitedUsers1 != nil {
//            invitedUsers = invitedUsers1!.compactMap({ (dict) -> InvitedUser? in
//                let invitedUser = InvitedUser(dict: dict)
//                return invitedUser
//            })
//        }
//        else {
//            invitedUsers = nil
//        }
        
        latitude = dict1["lat"] as? Double
        longitude = dict1["lng"] as? Double
        mainOrderId = dict1["main_order_id"] as? Int
        let isMenuIncludedInt = dict1["menu_included"] as? Int
        isMenuIncluded = ModelHelper.boolFromInt(isMenuIncludedInt)
        menuType = dict1["menu_type"] as? String
        orderHistoryType = dict1["order_history_type"] as? String
        orderStatus = dict1["order_status"] as? String
        orderType = dict1["order_type"] as? String
        orders = dict1["orders"] as? [[String: Any]]
        restaurantId = dict1["restaurant_id"] as? Int
        restaurantName = dict1["restaurant_name"] as? String
        restaurantPhoto = dict1["restaurant_photo"] as? String
        let updatedAtString = dict1["updated_at"] as? String
        updatedAt = ModelHelper.dateFromString(updatedAtString)
        userComment = dict1["user_comment"] as? String
        
        self.personName = dict1["person"] as? String
        self.personPhone = dict1["person_phone"] as? String
        self.guestsCount = Int("\(dict1["number_of_guests"] as? CVarArg ?? 0)")
         
    }
}

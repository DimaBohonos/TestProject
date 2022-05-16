//
//  InvitedOrder.swift

import UIKit

struct InvitedOrder {
    let address: String?
    let adminId: Int?
    let country: Any?
    let createdAt: Date?
    let creator_first_name: String?
    let creator_phone: String?
    let creator_photo: String?
    let creator_second_name: String?
    let dateFrom: Date?
    let dateTo: Date?
    let guarantor: String?
    let guarantor_creator_status: String?
    let id: Int?
//    let invitedUsers: [InvitedOrderUser]?
    let inviter_first_name: String?
    let inviter_phone: String?
    let inviter_photo: String?
    let inviter_second_name: String?
    let lat: Int?
    let lng: Int?
    let main_order_id: Int?
    let menu_included: Int?
    let menu_type: String?
    let order_history_type: String?
    let orderType: String?
    let orders: [[String: Any]]?
    let restaurantId: Int?
    let restaurantName: String?
    let restaurantPhoto: String?
    let status: String?
    
    init?(dict: [String:Any]?) {
        guard let dict1 = dict else {
            return nil
        }

        let createdAtString = dict1["created_at"] as? String
        createdAt = ModelHelper.dateFromString(createdAtString)
        let dateFromString = dict1["date_from"] as? String
        dateFrom = ModelHelper.dateFromString(dateFromString)
        let dateToString = dict1["date_to"] as? String
        dateTo = ModelHelper.dateFromString(dateToString)
        
        address = dict1["address"] as? String
        adminId = dict1["admin_id"] as? Int
        country = dict1["country"]

        creator_first_name = dict1["creator_first_name"] as? String
        creator_phone = dict1["creator_phone"] as? String
        creator_photo = dict1["creator_photo"] as? String
        creator_second_name = dict1["creator_second_name"] as? String
        guarantor = dict1["guarantor"] as? String
        guarantor_creator_status = dict1["guarantor_creator_status"] as? String
        let id1 = dict1["id"] as? Int
        guard id1 != nil else {
            return nil
        }
        id = id1!
//        let invitedUsersDicts = dict1["invitedUsers"] as? [[String: Any]]
//        if invitedUsersDicts != nil {
//            invitedUsers = invitedUsersDicts!.compactMap({ (dict) -> InvitedOrderUser? in
//                let user = InvitedOrderUser(dict: dict)
//                return user
//            })
//        }
//        else {
//            invitedUsers = nil
//        }
        
        inviter_first_name = dict1["inviter_first_name"] as? String
        inviter_phone = dict1["inviter_phone"] as? String
        inviter_photo = dict1["inviter_photo"] as? String
        inviter_second_name = dict1["inviter_second_name"] as? String
        lat = dict1["lat"] as? Int
        lng = dict1["lng"] as? Int
        main_order_id = dict1["main_order_id"] as? Int
        menu_included = dict1["menu_included"] as? Int
        menu_type = dict1["menu_type"] as? String
        order_history_type = dict1["order_history_type"] as? String
        orderType = dict1["order_type"] as? String
        orders = dict1["orders"] as? [[String: Any]]
        restaurantId = dict1["restaurant_id"] as? Int
        restaurantName = dict1["restaurant_name"] as? String
        restaurantPhoto = dict1["restaurant_photo"] as? String
        status = dict1["status"] as? String
    }
}

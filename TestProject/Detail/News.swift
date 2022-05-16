//
//  News.swift

import UIKit

struct News {
    let address: String?
    let campaign: String?
    let createdAt: Date?
    let date: Date?
    let description: String?
    let newsId: Int?
    let isDeleted: Bool?
    let latitude: Double?
    let longitude: Double?
    let mainPhoto: String?
    let phone: String?
    let photo: [[String: Any]]?
    let restaurantId: Int?
    let title: String?
    let updatedAt: Date?
    let website: String?
    
    init?(dict: [String:Any]?) {
        guard let dict1 = dict else {
            return nil
        }
        
        self.address = dict1["address"] as? String
        self.campaign = dict1["campaign"] as? String
        let createdAtString = dict1["created_at"] as? String
        self.createdAt = ModelHelper.dateFromString(createdAtString)
        let dateString = dict1["date"] as? String
        self.date = ModelHelper.dateFromString(dateString)
        self.description = dict1["description"] as? String
        self.newsId = dict1["id"] as? Int
        let isDeletedInt = dict1["is_deleted"] as? Int
        self.isDeleted = ModelHelper.boolFromInt(isDeletedInt)
        self.latitude = dict1["lat"] as? Double
        self.longitude = dict1["lng"] as? Double
        self.mainPhoto = dict1["main_photo"] as? String
        self.phone = dict1["phone"] as? String
        self.photo = dict1["photo"] as? [[String: Any]]
        self.restaurantId = dict1["restaurant_id"] as? Int
        self.title = dict1["title"] as? String
        let updatedAtString = dict1["updated_at"] as? String
        self.updatedAt = ModelHelper.dateFromString(updatedAtString)
        self.website = dict1["website"] as? String
    }
}

//
//  Comment.swift

import UIKit

struct Comment {
    let createdAt:Date?
    let commentId: Int?
    let restaurantId: Int?
    let isDeleted: Bool?
    let isPublished:Bool?
    let stars: Int?
    let text: String?
    let updatedAt: Date?
    let userFirstName: String?
    let userId: Int?
    let userSecondName: String?
    
    init?(dict: [String:Any]?) {
        guard let dict1 = dict else {
            return nil
        }
        
        let createdAtString = dict1["created_at"] as? String
        self.createdAt = ModelHelper.dateFromString(createdAtString)
        self.commentId = dict1["id"] as? Int
        self.restaurantId = dict1["restaurant_id"] as? Int
        let isDeletedInt = dict1["is_deleted"] as? Int
        self.isDeleted = ModelHelper.boolFromInt(isDeletedInt)
        let isPublishedInt = dict1["published"] as? Int
        self.isPublished = ModelHelper.boolFromInt(isPublishedInt)
        self.stars = dict1["stars"] as? Int
        self.text = dict1["text"] as? String
        let updatedAtString = dict1["updated_at"] as? String
        self.updatedAt = ModelHelper.dateFromString(updatedAtString)
        let userDict = dict1["user"] as? [String: Any]
        self.userFirstName = userDict?["first_name"] as? String
        self.userSecondName = userDict?["second_name"] as? String
        self.userId = dict1["user_id"] as? Int
    }
}

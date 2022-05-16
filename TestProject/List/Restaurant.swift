//
//  Restaurant.swift

import UIKit

struct Restaurant {
    let restaurantDict: [String: Any]
    let address: String?
    let countryId: Int?
    let createdAt: Date?
    let description: String?
    let favorites: Int?
    let gallery: [[String: Any]]?
    let id: Int
    let identificationCode: String?
    let exciseIdentificationCode: String?
    let imageSize: String?
    let interiorImage: String?
    let isDeleted: Bool?
//    let kitchenType: Any?
    let latitude: Double?
    let longitude: Double?
    let isMenuIncluded: Bool?
    let menuType: String?
    let name: String?
    let ownerId: Int?
    let phone: String?
    let photo: String?
    let isPreorder: Bool?
    let isPublished: Bool?
    let rating: Int?
    let ratingSort: Int?
    let restaurantCommentsCount: Int?
//    let restaurantTags:[Any]
    let schedule: String?
    let scheduleInfo: String?
    let shortDescription: String?
    let sortOrder: String?
    let status: String?
    let updatedAt: Date?
    let waitingDeposit: Int?
    let walletLogo: String?
    let website: String?
    let menuUrl: String?
    let deliveryPrice: Double?
    
    
    init?(dict: [String:Any]?) {
        guard let dict1 = dict else {
            return nil
        }
        
        
//        print(dict1)
        restaurantDict = dict1
        
        let address = dict1["address"] as? String
        let countryId = dict1["country_id"] as? Int
        let createdAtString = dict1["created_at"] as? String
        var createdAt: Date? = nil
        if createdAtString != nil {
            let createdAtFormatter = DateFormatter()
            createdAtFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            createdAt = createdAtFormatter.date(from: createdAtString!)
        }
        let description = dict1["description"] as? String
        let favorites = dict1["favorites"] as? Int
        let gallery = dict1["gallery"] as? [[String: Any]]
        let id = dict1["id"] as? Int
        let identificationCode = dict1["identification_code"] as? String
        
        let exciseIdentificationCode = dict1["identification_code_excise"] as? String
        
        let imageSize = dict1["image_size"] as? String
        let interiorImage = dict1["interior_image"] as? String
        let isDeletedInt = dict1["is_deleted"] as? Int
        var isDeleted: Bool? = nil
        if isDeletedInt != nil {
            isDeleted = (isDeletedInt! == 1) ? true : false
        }
    //    let kitchenType: Any?
        let latitude = dict1["lat"] as? Double
        let longitude = dict1["lng"] as? Double
        let isMenuIncludedInt = dict1["menu_included"] as? Int
        var isMenuIncluded: Bool? = nil
        if isMenuIncludedInt != nil {
            isMenuIncluded = (isMenuIncludedInt! == 1) ? true : false
        }
        let menuType = dict1["menu_type"] as? String
        let name = dict1["name"] as? String
        let ownerId = dict1["owner_id"] as? Int
        let phone = dict1["phone"] as? String
        let photo = dict1["photo"] as? String
        let isPreorderInt = dict1["pre_order"] as? Int
        var isPreorder: Bool? = nil
        if isPreorderInt != nil {
            isPreorder = (isPreorderInt! == 1) ? true : false
        }
        let isPublishedInt = dict1["published"] as? Int
        var isPublished: Bool? = nil
        if isPublishedInt != nil {
            isPublished = (isPublishedInt == 1) ? true : false
        }
        let rating = dict1["rating"] as? Int
        let ratingSort = dict1["rating_sort"] as? Int
        let restaurantCommentsCount = dict1["restaurant_comments_count"] as? Int
    //    let restaurantTags:[Any]
        let schedule = dict1["schedule"] as? String
        let scheduleInfo = dict1["schedule_info"] as? String
        let shortDescription = dict1["short_description"] as? String
        let sortOrder = dict1["sort_order"] as? String
        let status = dict1["status"] as? String
        let updatedAtString = dict1["updated_at"] as? String
        var updatedAt: Date? = nil
        if updatedAtString != nil {
            let updatedAtFormatter = DateFormatter()
            updatedAtFormatter.dateFormat = "YYYY-mm-dd HH:mm:ss"
            updatedAt = updatedAtFormatter.date(from: updatedAtString!)
        }
        let waitingDeposit = dict1["waiting_deposit"] as? Int
        let walletLogo = dict1["wallet_logo"] as? String
        let website = dict1["website"] as? String
                
        guard id != nil else {
            return nil
        }
        
        self.address = address
        self.countryId = countryId
        self.createdAt = createdAt
        self.description = description
        self.favorites = favorites
        self.gallery = gallery
        self.id = id!
        self.identificationCode = identificationCode
        self.exciseIdentificationCode = exciseIdentificationCode
        self.imageSize = imageSize
        self.interiorImage = interiorImage
        self.isDeleted = isDeleted
    //    self.kitchenType: Any?
        self.latitude = latitude
        self.longitude = longitude
        self.isMenuIncluded = isMenuIncluded
        self.menuType = menuType
        self.name = name
        self.ownerId = ownerId
        self.phone = phone
        self.photo = photo
        self.isPreorder = isPreorder
        self.isPublished = isPublished
        self.rating = rating
        self.ratingSort = ratingSort
        self.restaurantCommentsCount = restaurantCommentsCount
    //    self.restaurantTags:[Any]
        self.schedule = schedule
        self.scheduleInfo = scheduleInfo
        self.shortDescription = shortDescription
        self.sortOrder = sortOrder
        self.status = status
        self.updatedAt = updatedAt
        self.waitingDeposit = waitingDeposit
        self.walletLogo = walletLogo
        self.website = website
                
        menuUrl = dict1["pdf_menu"] as? String
        deliveryPrice = dict1["delivery_price"] as? Double
    }
}

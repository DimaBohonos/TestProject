//
//  RestaurantsRestaurant.swift
import Foundation

struct RestaurantsRestaurant {
    var restaurantId: Int
    var title: String
    var photoUrlString: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var distance: Double?
    let rating: Int?
    let restaurantCommentsCount: Int?
    let scheduleInfo: String?
    let phone: String?
}

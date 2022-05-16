//
//  RestaurantReviewCollectionViewCell.swift

import UIKit

class RestaurantReviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ratingView: RestaurantRatingView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
}

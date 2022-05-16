//
//  RestaurantReviewView.swift

import UIKit

protocol RestaurantReviewsViewDelegate: class {
    func showDetailedReview(review: RestaurantReview)
}

class RestaurantReviewsView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityView: ActivityView!
    fileprivate var reviews: [RestaurantReview] = []
    fileprivate weak var delegate: RestaurantReviewsViewDelegate?
    
    func setup(reviews: [RestaurantReview], delegate: RestaurantReviewsViewDelegate) {
        self.reviews = reviews
        self.delegate = delegate
        self.collectionView.reloadData()
    }
    
    @IBAction func reviewDetailButtonClick(sender: UIButton) {
        let buttonIndex = sender.tag
        let review = reviews[buttonIndex]
//        let reviewIdentifier = review.reviewIdentifier
        delegate?.showDetailedReview(review: review)
    }
}

extension RestaurantReviewsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsAmount = reviews.count
        return itemsAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "RestaurantReviewCellIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RestaurantReviewCollectionViewCell
        let review = reviews[indexPath.row]
        if review.rating != nil {
            cell.ratingView.setupRating(rating: review.rating!)
            cell.ratingView.isHidden  = false
        }
        else {
            cell.ratingView.isHidden  = true
        }
        cell.nameLabel.text = review.clientName
        
        if review.reviewDate != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            let dateString = formatter.string(from: review.reviewDate!)
            cell.dateLabel.text = dateString
        }
        else {
            cell.dateLabel.text = ""
        }
        cell.reviewLabel.text = review.review
//        cell.detailButton.tag = indexPath.row
//        cell.detailButton.addTarget(self, action: #selector(reviewDetailButtonClick(sender:)), for: .touchUpInside)
        
        cell.contentView.roundAllCorners()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (135.0 / 138.0) * collectionView.frame.height
        let width = (210.0 / 343.0) * collectionView.frame.width
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let review = reviews[indexPath.row]
//        let reviewIdentifier = review.reviewIdentifier
        delegate?.showDetailedReview(review: review)
        
    }
    
    func showActivityView(isLock: Bool, isDark: Bool) {
        activityView.showActivityIndicator(isLockScreen: isLock, isDark: isDark)
    }
    
    func hideActivityView() {
        activityView.hideActivityIndicator()
    }
}

//
//  RestaurantRatingView.swift

import UIKit

class RestaurantRatingView: UIView {
    @IBOutlet weak var contentView:UIView!
    @IBOutlet var starImageViews:[UIImageView]!
    
    var activeImage: UIImage? = UIImage(named: "Restaurant_ratingStar")
    var unactiveImage: UIImage? = UIImage(named: "Restaurant_ratingStar_unselected")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("RestaurantRatingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupRating(rating: Int) {
        var index = 0
        for starImageView in starImageViews {
//            starImageView.isHidden = !(index < rating)
            if (index < rating) {
                starImageView.image = activeImage
            }else{
                starImageView.image = unactiveImage
            }
            index += 1
        }
    }
}

//
//  RestaurantViewController.swift

import UIKit

class RestaurantViewController: UIViewController {
    lazy var presenter = RestaurantPresenter(view: self)
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    @IBOutlet weak var ratingView: RestaurantRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsView: RestaurantReviewsView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scheduleInfoLabel: UILabel!
    @IBOutlet weak var scheduleInfoSuperView: UIView!
    @IBOutlet weak var scheduleArrowImage: UIImageView!
    
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var webAddressButton: UIButton!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var detailedButton: UIButton!
    
    @IBOutlet weak var restaurantGalleryView: RestaurantGalleryView!
    @IBOutlet weak var reviewViewZeroHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewViewProportionalHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topViewWithPictureProportionalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewWithoutPictureProportionalHeightConstraint: NSLayoutConstraint!
    weak var topViewAddedProportionalHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var detailedButtonVisibleProportionalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailedButtonHiddenProportionalHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noNewsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thereIsNewsProportionalConstraint: NSLayoutConstraint!
    @IBOutlet weak var restaurantExitView: RestaurantExitView!
    
    @IBOutlet weak var menuViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deliveryViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuViewOutlet: UIView!
    @IBOutlet weak var deliveryViewOutlet: UIView!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
        
    var scheduleOn: Bool = false {
        didSet{
            self.configurateSchedule()
        }
    }
    
    func configurateSchedule() {
        
        if scheduleOn == true {
            
            self.scheduleInfoSuperView?.isHidden = false
            self.scheduleArrowImage?.image = UIImage(named: "schedule_arrow_top")
            
        }else{
            self.scheduleInfoSuperView?.isHidden = true
            self.scheduleArrowImage?.image = UIImage(named: "schedule_arrow_down")
        }
        
    }
    
    @IBAction func scheduleInfoButtonAction(_ sender: UIButton?) {
        scheduleOn = !scheduleOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded()
        
        deliveryButton?.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1).cgColor
        orderButton?.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1).cgColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        UserDefaultsService.setupDeliveryInterval(interval: nil)
    }
    
    deinit {
//        UserDefaultsService.setupDeliveryInterval(interval: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppeared()
        
        self.configurateSchedule()
    }
    
    @IBAction func closeButtonClick(sender: UIButton) {
        presenter.closeButtonTapped()
    }
    
    @IBAction func favouriteButtonButtonClick(sender: UIButton) {
//        if UserDefaultsService.getAuthorizedInAccount() {
//            let isSelected = sender.isSelected
//            presenter.favouriteButtonTapped(isSelected: isSelected)
//        } else {
//            performSegue(withIdentifier: "AuthScreen", sender: nil)
//        }
        
    }
    
    @IBAction func menuButtonClick(sender: UIButton) {
        presenter.menuButtonTapped()
    }
    
    @IBAction func deliveryButtonClick(sender: UIButton) {
        presenter.deliveryButtonTapped()
    }
    
    @IBAction func reservationButtonClick(sender: UIButton) {
//        if UserDefaultsService.getAuthorizedInAccount() {
//            presenter.reservationButtonTapped()
//        } else {
//            performSegue(withIdentifier: "AuthScreen", sender: nil)
//        }
    }
    
    @objc func collectionItemButtonClick(sender: UIButton) {
        let newsIndex = sender.tag
        presenter.collectionItemButtonTapped(newsIndex: newsIndex)
    }
    

    func setupRestaurant(restaurantRestaurant: RestaurantRestaurant) {
        presenter.setupRestaurant(restaurantRestaurant: restaurantRestaurant)
    }
    
    @IBAction func leaveReviewButtonClick(sender: UIButton) {
//        if UserDefaultsService.getAuthorizedInAccount() {
//            presenter.leaveReviewButtonTapped()
//        } else {
//            performSegue(withIdentifier: "AuthScreen", sender: nil)
//        }
    }
    
    @IBAction func addressButtonClick(sender: UIButton) {
        presenter.addressButtonTapped()
    }
    
    @IBAction func phoneButtonClick(sender: UIButton) {
        presenter.phoneButtonTapped()
    }
    
    @IBAction func webAddressButtonClick(sender: UIButton) {
        presenter.webAddressButtonTapped()
    }
    
    @IBAction func detailedButtonClick(sender: UIButton) {
        presenter.detailedButtonTapped()
    }
    
    @IBAction func deliveryCreateButtonClick(sender: UIButton) {
//        if UserDefaultsService.getAuthorizedInAccount() {
//            presenter.orderButtonTapped()
//        } else {
//            performSegue(withIdentifier: "AuthScreen", sender: nil)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
//        if segue.identifier == "CheckoutVCIdentifier" {
//            let restaurant = sender as! Restaurant
//            let vc = segue.destination as! CheckoutViewController
//            vc.setupData(restaurant: restaurant)
//        }
//
//        if segue.identifier == "RestaurantReviewDetailedVCIdentifier" {
//            let review = sender as! RestaurantReview?
//            guard review != nil else {
//                //TODO!
//                return
//            }
//            let vc = segue.destination as! RestaurantReviewDetailedViewController
//            vc.review = review
//        }
//        else if segue.identifier == "RestaurantReviewVCIdentifier" {
//            let restaurantId = sender as! Int
//            let vc = segue.destination as! RestaurantReviewViewController
//            vc.setupRestaurantId(restaurantId: restaurantId, delegate: self)
//        }
//        else if segue.identifier == "RestaurantsAddressVCIdentifier" {
//            let restaurantsLocation = sender as! RestaurantsLocation
//            let vc = segue.destination as! RestaurantAddressViewController
//            vc.setupLocation(location: restaurantsLocation)
//        }
//        else if segue.identifier == "RestaurantEventVCIdentifier" {
//            let restaurantNews = sender as! RestaurantNews
//            let vc = segue.destination as! RestaurantEventViewController
//            vc.setupNews(restaurantNews: restaurantNews)
//        }
//        else if segue.identifier == "ReservationVCIdentifier" {
//            let restaurantRestaurant = sender as! RestaurantRestaurant
//            let vc = segue.destination as! RestoranOrderViewController
//            vc.setupRestaurantInfo(restaurantRestaurant.restaurantDict)
//        }
//        else if segue.identifier == "DeliveryProductsVCIdentifier" {
//            let restaurantRestaurant = sender as! RestaurantRestaurant
//            let vc = segue.destination as! DeliveryProductsViewController
//            vc.setupRestaurant(restaurantRestaurant: restaurantRestaurant)
//        }
//        else if segue.identifier == "RestaurantMenuVCIdentifier" {
//            let menuUrl = sender as! String
//            let vc = segue.destination as! RestaurantMenuViewController
//            vc.setupMenuUrl(menuUrl: menuUrl)
//        } else if segue.identifier == "AuthScreen" {
//            let vc = segue.destination
//            vc.modalPresentationStyle = .fullScreen
//        }
    }
    
    func setupTopViewContraintForImageSize(size: CGSize) {
        if topViewAddedProportionalHeightConstraint == nil {
            topView.translatesAutoresizingMaskIntoConstraints = false
            let multiplier: CGFloat = size.height / size.width
            print("multiplier = \(multiplier)")
//            let newConstraint = NSLayoutConstraint(item: topView!, attribute: .height, relatedBy: .equal, toItem: topView, attribute: .width, multiplier: multiplier, constant: 0)
//            topView.addConstraint(newConstraint)
            NSLayoutConstraint(item: topView!, attribute: .height, relatedBy: .equal, toItem: topView, attribute: .width, multiplier: multiplier, constant: 0).isActive = true
//            topViewAddedProportionalHeightConstraint = newConstraint

            topViewWithoutPictureProportionalHeightConstraint.isActive = false
            topViewWithPictureProportionalHeightConstraint.isActive = false

            self.view.layoutIfNeeded()
            restaurantGalleryView.reloadData()
        }
    }
    
    func updateDeliveryButton() {
        let totalSum = presenter.takeTotalSum()
        if totalSum > 0 {
//            let sumString = PriceService.takePriceWithCurrency(price: totalSum)
//            deliveryButtonView.label?.text = sumString
//            deliveryButtonView.isHidden = false
        }
        else {
//            deliveryButtonView.label?.text = ""
//            deliveryButtonView.isHidden = true
        }
    }
    
}



extension RestaurantViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let news = presenter.news
        let itemsAmount = news.count
        return itemsAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "RestaurantCollectionCellIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RestaurantCollectionViewCell
        
        let news = presenter.news
        let news1 = news[indexPath.row]
        
        let urlString = news1.mainPhoto
        if urlString != nil {
            let photoUrlString = "https://back.chichiko-and-co.com.ua" + "/images/restaurants/" + "news/" + urlString!
            let url = URL(string: photoUrlString)
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        else {
            cell.imageView.image = nil
        }
        
        cell.titleLabel.text = news1.title
        
        if let date = news1.date {
            
            let dateFormat = "MM/dd/yy"
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = dateFormat
            
            cell.dateLabel?.text = dateFormatter.string(from: date)
            
        }else{
            cell.dateLabel?.text = ""
        }
        
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(collectionItemButtonClick(sender:)), for: .touchUpInside)
        
        cell.containerView.roundAllCorners()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (99.0 / 107.0) * collectionView.frame.height
        let width = (163.0 / 343.0) * collectionView.frame.width
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //        let interItemsSpace = ((343.0 - 2.0 * 163.0) / 343.0) * collectionView.frame.width
        var koef: CGFloat = (343.0 - 2.0 * 163.0) / 343.0
        koef = koef * (343.0 / 375.0)
        let interItemsSpace = koef * self.view.frame.width
        return interItemsSpace
    }
}

extension RestaurantViewController: RestaurantPresenterView {
    func showErrorAlert(message: String) {
        
    }
    
    func reloadRestaurantCollectionView() {
        let news = presenter.news
        if news.count == 0 {
            noNewsHeightConstraint.isActive = true
            thereIsNewsProportionalConstraint.isActive = false
        }
        else {
            noNewsHeightConstraint.isActive = false
            thereIsNewsProportionalConstraint.isActive = true
        }
        
        restaurantCollectionView.reloadData()
    }
    
    func setupBottomViewCornerRadius() {
        bottomView.roundAllCorners()
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupRating(rating: Int?) {
        if rating != nil {
            ratingView.setupRating(rating: rating!)
            ratingLabel.text = "\(rating!)"
            ratingView.isHidden = false
            ratingLabel.isHidden = false
        }
        else {
            ratingView.isHidden = true
            ratingLabel.isHidden = true
        }
    }
    
    func updateReviews(reviews: [RestaurantReview]) {
        self.reviewsView.setup(reviews: reviews, delegate:  self)
        let reviewsIsHidden = reviews.count == 0
        reviewsView.isHidden = reviewsIsHidden
        reviewViewZeroHeightConstraint.isActive = reviewsIsHidden
        reviewViewProportionalHeightConstraint.isActive = !reviewsIsHidden
        self.view.layoutIfNeeded()
    }
    
    func showRestaurantReviewDetailedVC() {
//        let review = presenter.selectedReview
//        performSegue(withIdentifier: "RestaurantReviewDetailedVCIdentifier", sender: review)
    }
    
    func showRestaurantReviewVC(restaurantId: Int) {
//        performSegue(withIdentifier: "RestaurantReviewVCIdentifier", sender: restaurantId)
    }
    
    func showRestaurantAddressVC(restaurantsLocation: RestaurantsLocation) {
//        self.performSegue(withIdentifier: "RestaurantsAddressVCIdentifier", sender: restaurantsLocation)
    }
    
    func showRestaurantEventVC(restaurantNews: RestaurantNews) {
//        self.performSegue(withIdentifier: "RestaurantEventVCIdentifier", sender: restaurantNews)
    }
    
    func updateData() {
        
        guard let restaurant = presenter.restaurantRestaurant else {
            return
        }
        
//        print(restaurant.scheduleInfo)
//        print(restaurant.restaurantDict)
        
        titleLabel?.text = restaurant.name
//        scheduleInfoLabel.attributedText = restaurant.scheduleInfo?.htmlToAttributedString
        scheduleInfoLabel.setHTMLFromString(htmlText: restaurant.scheduleInfo ?? "")
        scheduleInfoLabel.textColor = UIColor.init(named: "616161")
        
        
        addressButton.setTitle(restaurant.address, for: .normal)
        phoneButton.setTitle(restaurant.phone, for: .normal)
        webAddressButton.setTitle(restaurant.webAddress, for: .normal)
        shortDescriptionLabel.text = restaurant.shortDescription
        var galleryImagesUrls = restaurant.galleryImages.map { (imageName) -> String in
            let urlString = "https://back.chichiko-and-co.com.ua" + "/images/restaurants/" + imageName
            return urlString
        }
        
        if topViewAddedProportionalHeightConstraint == nil {
            if galleryImagesUrls.count == 0 {
                topViewWithoutPictureProportionalHeightConstraint.isActive = true
                topViewWithPictureProportionalHeightConstraint.isActive = false
            }
            else {
                topViewWithoutPictureProportionalHeightConstraint.isActive = false
                topViewWithPictureProportionalHeightConstraint.isActive = true
            }
        }
         
        let last = galleryImagesUrls.last ?? ""
        let first = galleryImagesUrls.first ?? ""

        galleryImagesUrls.append(first)
        galleryImagesUrls.insert(last, at: 0)
        
        restaurantGalleryView.setupImagesUrls(urls: galleryImagesUrls, delegate: self)
        
        
        menuViewHeightConstraint.constant = 59.0 * Scalable.scale
        if restaurant.menuUrl != nil {
//            menuViewHeightConstraint.constant = 59.0 * Scalable.scale
            menuButton.isHidden = false
            menuViewOutlet?.isHidden = false
        }
        else {
//            menuViewHeightConstraint.constant = 16.0 * Scalable.scale
            menuButton.isHidden = true
            menuViewOutlet?.isHidden = true
        }
        
        
        deliveryViewHeightConstraint.constant = 59.0 * Scalable.scale
        if restaurant.isMenuIncluded != nil, restaurant.isMenuIncluded! == true {
//            deliveryViewHeightConstraint.constant = 59.0 * Scalable.scale
            deliveryButton.isHidden = false
            deliveryViewOutlet?.isHidden = false
        }
        else {
//            deliveryViewHeightConstraint.constant = 0
            deliveryButton.isHidden = true
            deliveryViewOutlet?.isHidden = true
        }
        
        self.updateDeliveryButton()
        
        self.view.layoutIfNeeded()
    }
    
    func updateFavouriteButton(isHidden: Bool?, isSelected: Bool?, isEnabled: Bool?) {
        if isHidden != nil {
            favouriteButton.isHidden = isHidden!
        }
        if isSelected != nil {
            favouriteButton.isSelected = isSelected!
        }
        if isEnabled != nil {
            favouriteButton.isEnabled = isEnabled!
        }
    }
    
    func showFullDescription() {
        guard let restaurant = presenter.restaurantRestaurant else {
            return
        }
        var descriptionText = ""
        if restaurant.shortDescription != nil && restaurant.description != nil {
            descriptionText = restaurant.shortDescription! + " " + restaurant.description!
        }
        else if restaurant.shortDescription != nil {
            descriptionText = restaurant.shortDescription!
        }
        else if restaurant.description != nil {
            descriptionText = restaurant.description!
        }
        shortDescriptionLabel.text = descriptionText
    }
    
    func hideDetailedButton() {
        detailedButton.isHidden = true
        
        detailedButtonVisibleProportionalHeightConstraint.isActive = false
        detailedButtonHiddenProportionalHeightConstraint.isActive = true
    }
    
    func showReservationVC(restaurantRestaurant: RestaurantRestaurant) {
//        self.performSegue(withIdentifier: "ReservationVCIdentifier", sender: restaurantRestaurant)
    }
    
    func showDeliveryVC(restaurantRestaurant: RestaurantRestaurant) {
//        self.performSegue(withIdentifier: "DeliveryProductsVCIdentifier", sender: restaurantRestaurant)
    }
    
    func showCommentsActivityView(isLock: Bool) {
        reviewsView.showActivityView(isLock: isLock, isDark: true)
    }
    
    func hideCommentsActivityView() {
        reviewsView.hideActivityView()
    }
    
    func showRestaurantExitView() {
        restaurantExitView.showView(delegate: self)
    }
    
    func hideRestaurantExitViewWithoutAnimation() {
        restaurantExitView.hideWithoutAnimation()
    }
    
    func showMenuVC(menuUrl: String) {
//        performSegue(withIdentifier: "RestaurantMenuVCIdentifier", sender: menuUrl)
    }
    
    func showCheckoutVC(restaurant: Restaurant) {
//        performSegue(withIdentifier: "CheckoutVCIdentifier", sender: restaurant)
    }
    
}

extension RestaurantViewController: RestaurantReviewsViewDelegate {
    func showDetailedReview(review: RestaurantReview) {
        presenter.reviewDetailButtonTapped(review: review)
    }
}

extension RestaurantViewController: RestaurantGalleryViewDelegate {
    func imageWasLoadedWithSize(size: CGSize) {
//        setupTopViewContraintForImageSize(size: size)
    }
}

//extension RestaurantViewController: RestaurantReviewViewControllerDelegate {
//    func reviewCouldBeLeft() {
//        presenter.reviewCouldBeLeft()
//    }
//}

extension RestaurantViewController: RestaurantExitViewDelegate {
    func exitButtonTapped() {
        presenter.exitButtonTapped()
    }
    
    func stayInRestaurantButtonTapped() {
        presenter.stayInRestaurantButtonTapped()
    }
}

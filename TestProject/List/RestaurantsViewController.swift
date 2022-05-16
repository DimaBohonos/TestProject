//
//  RestaurantsViewController.swift

import UIKit
import SDWebImage
import CoreLocation

class RestaurantsViewController: UIViewController {
    lazy var presenter = RestaurantsPresenter(view: self)
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var restaurantsTableView: UITableView!
    @IBOutlet weak var restaurantsTableBackgroundView: ActivityView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var profileNameLabel: UILabel!
//    @IBOutlet weak var darkBackgroundView: UIView!
//    @IBOutlet weak var searchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded()
        
        roundProfileImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppeared()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func profileButtonClick(sender: UIButton) {
//        if UserDefaultsService.getAuthorizedInAccount() {
//            presenter.profileButtonTapped()
//        } else {
//            performSegue(withIdentifier: "AuthScreen", sender: nil)
//        }
    }
    
    @IBAction func locationButtonClick(sender: UIButton) {
        presenter.locationButtonTapped()
    }
    
    @IBAction func searchTextFieldEditingChanged(sender: UITextField) {
        presenter.searchTextFieldTextEditingChanged()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "RestaurantsLocationVCIdentifier" {
//            let restaurantsLocations = sender as! [RestaurantsLocation]
//            let vc = segue.destination as! RestaurantsLocationViewController
//            vc.setupLocations(locations: restaurantsLocations)
//        } else
        if segue.identifier == "RestaurantVCIdentifier" {
            let restaurantRestaurant = sender as! RestaurantRestaurant
            let vc = segue.destination as! RestaurantViewController
            vc.setupRestaurant(restaurantRestaurant: restaurantRestaurant)
        }
//        else if segue.identifier == "ProfileVCIdentifier" {
//            let vc = segue.destination as! ProfileViewController
//            vc.setupDelegate(delegate: self)
//        } else if segue.identifier == "AuthScreen" {
//            let vc = segue.destination
//            vc.modalPresentationStyle = .fullScreen
//        }
    }
    
    func takeUserLocation() -> (latitude: Double, longitude: Double)? {
        let userLocation = self.locationManager?.location
        guard let latitude = userLocation?.coordinate.latitude, let longitude = userLocation?.coordinate.longitude else {
            return nil
        }
        let coord = (Double(latitude), Double(longitude))
        return coord
    }
    
    func startUpdateLocations() {
        if locationManager == nil {
            self.locationManager = CLLocationManager()
        }
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    
//    func setupUser(user: User?) {
//        presenter.setupUser(user: user)
//    }
    
    func convertDistance(distance: Double) -> String {
        var distanceString: String
        if distance < 1000.0 {
            let distanceInt = Int(distance)
            distanceString = "\(distanceInt) метрів"
        }
        else {
            let distanceInt = Int(distance / 1000.0)
            distanceString = "\(distanceInt) км"
        }
        return distanceString
    }
    
    func setupPlaceholder() {
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Введіть назву",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}

extension RestaurantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellsAmount = presenter.takeCellsAmount()
        return cellsAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTypeAndRestaurantOrOrderOrInvited = presenter.takeCellInfo(index: indexPath.row)
//        let cellType = cellTypeAndRestaurantOrOrderOrInvited.cellType
//
//        switch cellType {
//        case .restaurant:
            var restaurantName: String? = nil
            var photoUrlString: String? = nil
            let cellIdentifier = "RestaurantsCellIdentifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantsTableViewCell
            
            let restaurant = cellTypeAndRestaurantOrOrderOrInvited.restaurantsRestaurant!
            var addressText = ""
            if let distance = restaurant.distance {
                addressText = convertDistance(distance: distance)
                if restaurant.address != nil {
                    addressText += ", "
                    addressText += restaurant.address!
                }
            }
            else {
                addressText = restaurant.address ?? ""
            }
            cell.restaurantAddressLabel.text = addressText
            
            restaurantName = restaurant.title
            photoUrlString = restaurant.photoUrlString
            
            
//            cell.workTimeLabel.text = restaurant.scheduleInfo
//            restaurantRating = restaurant.rating
            
            cell.restaurantTitleLabel.text = restaurantName

            cell.restaurantPhotoImageView.clipsToBounds = true
        cell.restaurantPhotoImageView.layer.cornerRadius = 10.0//cornerRadius * Scalable.scale
            
            if photoUrlString != nil {
                let photoUrl = URL(string: photoUrlString!)
                cell.restaurantPhotoImageView.sd_setImage(with: photoUrl, completed: nil)
            }
            else {
                cell.restaurantPhotoImageView.image = nil
            }
            
            return cell
//        case .delivery:
//            let cellIdentifier = "RestaurantsDeliveryCellIdentifier"
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantsOrderTableViewCell
//
//            var restaurantName: String? = nil
//            var time = ""
//            let deliveryOrder = cellTypeAndRestaurantOrOrderOrInvited.deliveryOrder
//            if deliveryOrder != nil {
//                restaurantName = deliveryOrder?.restaurant_name
//
//                if let date_delivery = deliveryOrder?.delivery?.date_delivery {
//                    let dateDateFormatter = DateFormatter()
//                    dateDateFormatter.dateFormat = "dd.MM.yy"
//                    dateDateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
//                    let dateString = dateDateFormatter.string(from: date_delivery)
//                    time = dateString
//                }
//                if let time_delivery = deliveryOrder?.delivery?.time_delivery {
//                    let timeDateFormatter = DateFormatter()
//                    timeDateFormatter.dateFormat = "HH:mm"
//                    timeDateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
//                    let timeString = timeDateFormatter.string(from: time_delivery)
//                    time = time + "\n" + timeString
//                }
//            }
//            cell.timeLabel.text = time
//            cell.restaurantTitleLabel.text = restaurantName
//
//            return cell
//        case .reservation:
//            let cellIdentifier = "RestaurantsReservationCellIdentifier"
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantsOrderTableViewCell
//
//            var restaurantName: String? = nil
//            var time = ""
//            let order = cellTypeAndRestaurantOrOrderOrInvited.order
//            let invitedOrder = cellTypeAndRestaurantOrOrderOrInvited.invitedOrder
//            if order != nil {
//                restaurantName = order?.restaurantName
//
//                if let dateFrom = order?.dateFrom {
//                    let dateDateFormatter = DateFormatter()
//                    dateDateFormatter.dateFormat = "dd.MM.yy"
//                    dateDateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
//                    let dateString = dateDateFormatter.string(from: dateFrom)
//
//                    let timeDateFormatter = DateFormatter()
//                    timeDateFormatter.dateFormat = "HH:mm"
//                    timeDateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
//                    let timeString = timeDateFormatter.string(from: dateFrom)
//                    time = dateString + "\n" + timeString
//                }
//                else {
//                    time = ""
//                }
//            }
//            else if invitedOrder != nil {
//                restaurantName = invitedOrder?.restaurantName
//
//                if let dateFrom = invitedOrder?.dateFrom {
//                    let dateDateFormatter = DateFormatter()
//                    dateDateFormatter.dateFormat = "dd.MM.yy"
//                    dateDateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
//                    let dateString = dateDateFormatter.string(from: dateFrom)
//
//                    let timeDateFormatter = DateFormatter()
//                    timeDateFormatter.dateFormat = "HH:mm"
//                    timeDateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
//                    let timeString = timeDateFormatter.string(from: dateFrom)
//
//                    time = dateString + "\n" + timeString
//                }
//                else {
//                    time = ""
//                }
//            }
//            cell.timeLabel.text = time
//            cell.restaurantTitleLabel.text = restaurantName
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight = presenter.takeCellHeight(index: indexPath.row)
        return rowHeight
//        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tableViewRowTapped(rowIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 1, height: 14))
        view.backgroundColor = .clear
        
        return view
        
    }
}

extension RestaurantsViewController: RestaurantsPresenterView {
    func showErrorAlert(message: String) {
        
    }
    
    func reloadRestaurantsTableView() {
        restaurantsTableView.reloadData()
    }
    
    func showProfileVC() {
//        self.performSegue(withIdentifier: "ProfileVCIdentifier", sender: nil)
    }
    
    func showRestaurantVC(restaurantRestaurant: RestaurantRestaurant) {
        self.performSegue(withIdentifier: "RestaurantVCIdentifier", sender: restaurantRestaurant)
    }
    
    func takeTextForRestaurantsFiltering() -> String {
        let filterText = searchTextField.text ?? ""
        return filterText
    }
    
    func showRestaurantsLocationVC(restaurantsLocations: [RestaurantsLocation]) {
//        self.performSegue(withIdentifier: "RestaurantsLocationVCIdentifier", sender: restaurantsLocations)
    }
    
    func disableSwipingToPreviousVC() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    func updateProfileName(userName: String) {
        
        profileNameLabel?.text = userName
        
    }
    
//    func updateProfileImage(imageName: String) {
//        if profileButton != nil {
//            let photoUrlString = Constants.Server.serverAvatarImagesUrl + imageName
//            let url = URL(string: photoUrlString)
//            profileButton.sd_setBackgroundImage(with: url, for:.normal, completed: nil)
//            profileButton.sd_setBackgroundImage(with: url, for: .normal, placeholderImage: UIImage(named: "Restaurants_profileImage"), options: [], completed: nil)
//            
//            
//            
//            roundProfileImage()
//        }else{
////            profileButton.layer.borderWidth = 2
////            profileButton.layer.borderColor = #colorLiteral(red: 1, green: 0.7960784314, blue: 0.2549019608, alpha: 1).cgColor
//            roundProfileImage()
//        }
//    }
    
    func roundProfileImage() {
        
        profileButton.clipsToBounds = true
        let buttonWidth: CGFloat = 40.0
        profileButton.layer.cornerRadius = buttonWidth / 2.0// * Scalable.scale
        
        profileButton.layer.borderWidth = 2
        profileButton.layer.borderColor = #colorLiteral(red: 1, green: 0.7960784314, blue: 0.2549019608, alpha: 1).cgColor
        
    }
    
    func showActivityIndicatorForRestaurantsLoading() {
        restaurantsTableBackgroundView.showActivityIndicator()
    }
    
    func hideActivityIndicatorForRestaurantsLoading() {
        restaurantsTableBackgroundView.hideActivityIndicator()
    }
    
    func showActivityIndicatorForRestaurantWithIdLoading() {
        (view as! ActivityView).showActivityIndicator()
    }
    
    func hideActivityIndicatorForRestaurantWithIdLoading() {
        (view as! ActivityView).hideActivityIndicator()
    }
    
    func showReservationsActivityIndicator(isLock: Bool) {
        restaurantsTableBackgroundView.showActivityIndicator(isLockScreen: isLock, isDark: false)
    }
    
    func hideReservationsActivityIndicator() {
        restaurantsTableBackgroundView.hideActivityIndicator()
    }
    
//    func showReservationConfirmVC(order: Order) {
//        let reservationStoryboard = UIStoryboard(name: "Reservation", bundle: nil)
//        var vc: ReservationConfirmViewController
//        if #available(iOS 13.0, *) {
//            vc = reservationStoryboard.instantiateViewController(identifier: "ReservationConfirmIdentifier")
//        } else {
//            vc = reservationStoryboard.instantiateViewController(withIdentifier: "ReservationConfirmIdentifier") as! ReservationConfirmViewController
//        }
//        vc.setupOrder(order: order, delegate: self)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
//    }
    
//    func showInvitedOrderVC(invitedOrder: InvitedOrder) {
//        let reservationStoryboard = UIStoryboard(name: "Reservation2", bundle: nil)
//        var vc: ReservationInvitedViewController
//        if #available(iOS 13.0, *) {
//            vc = reservationStoryboard.instantiateViewController(identifier: "ReservationInvitedViewControllerIdentifier")
//        } else {
//            vc = reservationStoryboard.instantiateViewController(withIdentifier: "ReservationInvitedViewControllerIdentifier") as! ReservationInvitedViewController
//        }
//        vc.setupInvitedOrder(invitedOrder: invitedOrder)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
//    }
    
    func showActivityIndicator(isLock: Bool) {
        restaurantsTableBackgroundView.showActivityIndicator(isLockScreen: isLock, isDark: false)
    }
    
    func hideActivityIndicator() {
        restaurantsTableBackgroundView.hideActivityIndicator()
    }
    
//    func showCheckViewController(deliveryOrder: DeliveryOrder) {
//        let storyboard = UIStoryboard(name: "Check", bundle: nil)
//        var vc: CheckViewController
//        if #available(iOS 13.0, *) {
//            vc = storyboard.instantiateViewController(identifier: "CheckViewControllerIdentifier")
//        } else {
//            vc = storyboard.instantiateViewController(withIdentifier: "CheckViewControllerIdentifier") as! CheckViewController
//        }
//        vc.setupDeliveryOrder(deliveryOrder: deliveryOrder)
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        present(vc, animated: true, completion: nil)
//    }
}

extension RestaurantsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}

extension RestaurantsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locationManager?.location?.coordinate.latitude
        let longitude = locationManager?.location?.coordinate.longitude
        if latitude != nil, longitude != nil {
            presenter.userLocationWasUpdated(latitude: latitude!, longitude: longitude!)
            locationManager?.stopUpdatingLocation()
            
        }
    }
}

//extension RestaurantsViewController: ProfileViewControllerDelegate {
//    func profilePictureWasChanged() {
//        presenter.profilePictureWasChanged()
//    }
//}

//extension RestaurantsViewController: ReservationConfirmViewControllerDelegate {
//    func updatePreviousScreenIfNecessary() {
//        // Do nothing
//    }
//}

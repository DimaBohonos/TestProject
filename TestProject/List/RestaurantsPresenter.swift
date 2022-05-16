//
//  RestaurantsPresenter.swift

import UIKit
import CoreLocation

protocol RestaurantsPresenterView: class {
    func reloadRestaurantsTableView()
    func showProfileVC()
    func showRestaurantVC(restaurantRestaurant: RestaurantRestaurant)
    func showErrorAlert(message: String)
    func takeTextForRestaurantsFiltering() -> String
    func showRestaurantsLocationVC(restaurantsLocations: [RestaurantsLocation])
    func startUpdateLocations()
    func disableSwipingToPreviousVC()
//    func updateProfileImage(imageName: String)
    func updateProfileName(userName: String)
    func showActivityIndicatorForRestaurantsLoading()
    func hideActivityIndicatorForRestaurantsLoading()
    func showActivityIndicatorForRestaurantWithIdLoading()
    func hideActivityIndicatorForRestaurantWithIdLoading()
    func showReservationsActivityIndicator(isLock: Bool)
    func hideReservationsActivityIndicator()
    func roundProfileImage()
//    func showReservationConfirmVC(order: Order)
    func setupPlaceholder()
//    func showInvitedOrderVC(invitedOrder: InvitedOrder)
    func showActivityIndicator(isLock: Bool)
    func hideActivityIndicator()
//    func showCheckViewController(deliveryOrder: DeliveryOrder)
}

class RestaurantsPresenter {
    weak var view:RestaurantsPresenterView!
    private var restaurants:[Restaurant] = []
    private var restaurantsRestaurant:[RestaurantsRestaurant] = []
    var restaurantsRestaurantsFiltered:[RestaurantsRestaurant] = [] {
        didSet {
            view.reloadRestaurantsTableView()
        }
    }
    var userLocation: RestaurantUserLocation? = nil
    var lastUpdateDate: Date? = nil
//    var user: User?
    var deliveries:[DeliveryOrder] = [] {
        didSet {
            view.reloadRestaurantsTableView()
        }
    }
    var reservationOrders:[Order] = [] {
        didSet {
            view.reloadRestaurantsTableView()
        }
    }
    var invitedOrders:[InvitedOrder] = [] {
        didSet {
            view.reloadRestaurantsTableView()
        }
    }
    
    init(view: RestaurantsPresenterView) {
        self.view = view
    }
    var favouritesRestaurantIdsDict: [Int:Int]? = nil
    var isFavouritesLoaded = false
    var isRestaurantsLoaded = false
    var isSorted = false
    
    func viewDidLoaded() {
        view.roundProfileImage()
        view.startUpdateLocations()
        view.disableSwipingToPreviousVC()
        view.setupPlaceholder()
    }
    
    func viewWillAppeared() {
        let isNecessaryToUpdate = isNecessaryToUpdateRestaurants()
        if isNecessaryToUpdate {
            loadRestaurants()
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
//            self.updateProfileImage()
            self.loadActiveReservations()
            self.loadActiveDeliveries()
            self.loadFavourites()
        }
        
    }
    
    func profileButtonTapped() {
        view.showProfileVC()
    }
    
    func locationButtonTapped() {
        var restaurantsLocations = [RestaurantsLocation]()
        for restaurant in restaurants {
            let restaurantId = restaurant.id
            let latitude = restaurant.latitude
            let longitude = restaurant.longitude
            let restaurantName = restaurant.name
            let restaurantAddress = restaurant.address
            
            if latitude != nil, longitude != nil, restaurantName != nil {
                let restaurantsLocation = RestaurantsLocation(restaurantId: restaurantId, latitude: latitude!, longitude: longitude!, restaurantName: restaurantName!, restaurantAddress: restaurantAddress)
                restaurantsLocations.append(restaurantsLocation)
            }
        }
        if restaurantsLocations.count > 0 {
            view.showRestaurantsLocationVC(restaurantsLocations: restaurantsLocations)
        }
        else {
            view.showErrorAlert(message: "Локації ресторанів не знайдено")
        }
    }
    
    func loadRestaurants() {
        view.showActivityIndicatorForRestaurantsLoading()
        ServerManager.shared.restaurants { [weak self] (isSuccess, result, value) in
            self?.view.hideActivityIndicatorForRestaurantsLoading()
            if isSuccess == true {
                if result == .success && value != nil {
                    self?.isRestaurantsLoaded = true
                    self?.lastUpdateDate = Date()
                    self?.restaurants = value!.restaurants
                    self?.showRestaurants(restaurants: value!.restaurants)
                }
                else {
                    self?.view.showErrorAlert(message: "Інформацію про ресторани завантажити не вдалося")
                }
            }
            else {
                self?.view.showErrorAlert(message: "Інформацію про ресторани завантажити не вдалося")
            }
        }
    }
    
    func showRestaurants(restaurants: [Restaurant]) {
        var restaurants1:[RestaurantsRestaurant] = []
        for restaurant in restaurants {
            if restaurant.name != nil {
                var photoUrlString: String? = nil
                if restaurant.photo != nil {
                    photoUrlString = "https://back.chichiko-and-co.com.ua" + "/images/restaurants/" + restaurant.photo!
                }
                let restaurantRestaurant = RestaurantsRestaurant(restaurantId: restaurant.id, title: restaurant.name!, photoUrlString: photoUrlString, address: restaurant.address, latitude: restaurant.latitude, longitude: restaurant.longitude, rating: restaurant.rating, restaurantCommentsCount: restaurant.restaurantCommentsCount, scheduleInfo: restaurant.scheduleInfo, phone: restaurant.phone)
                restaurants1.append(restaurantRestaurant)
            }
        }
        self.restaurantsRestaurant = restaurants1
        sortRestaurantsRestaurantIfCan()
        updateRestaurantsFiltered()
    }
    
    func updateRestaurantsFiltered() {
        let text = view.takeTextForRestaurantsFiltering()
        let filterText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if filterText.count >= 1 {
            self.restaurantsRestaurantsFiltered = self.restaurantsRestaurant.filter { restaurant in
                return restaurant.title.range(of: filterText, options: .caseInsensitive) != nil
            }
        }
        else {
            self.restaurantsRestaurantsFiltered = self.restaurantsRestaurant
        }
    }
    
    func searchTextFieldTextEditingChanged() {
        updateRestaurantsFiltered()
    }
    
    func userLocationWasUpdated(latitude: Double, longitude: Double) {
        if userLocation == nil {
            userLocation = RestaurantUserLocation(latitude: latitude, longitude: longitude)
            sortRestaurantsRestaurantIfCan()
            updateRestaurantsFiltered()
        }
    }
    
    func sortRestaurantsRestaurantIfCan() {
        if userLocation != nil {
            let latitude1 = userLocation!.latitude
            let longitude1 = userLocation!.longitude
            let userCLLocation = CLLocation(latitude: latitude1, longitude: longitude1)
            
            self.restaurantsRestaurant = restaurantsRestaurant.map { (restaurant) -> RestaurantsRestaurant in
                let latitude = restaurant.latitude
                let longitude = restaurant.longitude
                if latitude != nil, longitude != nil {
                    let location = CLLocation(latitude: latitude!, longitude: longitude!)
                    let distance = Double(location.distance(from: userCLLocation))
                    let restaurant1 = RestaurantsRestaurant(restaurantId: restaurant.restaurantId, title: restaurant.title, photoUrlString: restaurant.photoUrlString, address: restaurant.address, latitude: restaurant.latitude, longitude: restaurant.longitude, distance: distance, rating: restaurant.rating, restaurantCommentsCount: restaurant.restaurantCommentsCount, scheduleInfo: restaurant.scheduleInfo, phone: restaurant.phone)
                    return restaurant1
                }
                else {
                    return restaurant
                }
            }
        }
        if let restaurantIdsDict = favouritesRestaurantIdsDict {
            self.restaurantsRestaurant = restaurantsRestaurant.sorted(by: { (restaurantsRestaurant1, restaurantsRestaurant2) -> Bool in
                
                let restaurantId1 = restaurantIdsDict[restaurantsRestaurant1.restaurantId]
                let isFound1 = restaurantId1 != nil
                let restaurantId2 = restaurantIdsDict[restaurantsRestaurant2.restaurantId]
                let isFound2 = restaurantId2 != nil
                if isFound1 != isFound2 {
                    if isFound1 && !isFound2 {
                        return true
                    }
                    else if isFound2 && !isFound1 {
                        return false
                    }
                    return true
                }
                else {
                    let distance1 = restaurantsRestaurant1.distance
                    let distance2 = restaurantsRestaurant2.distance
                    if distance1 != nil, distance2 != nil {
                        if distance1! != distance2! {
                            let isFirstLocationCloser = distance1! < distance2!
                            return isFirstLocationCloser
                        }
                        else {
                            return restaurantsRestaurant1.restaurantId < restaurantsRestaurant2.restaurantId
                        }
                    }
                    else {
                        return restaurantsRestaurant1.restaurantId < restaurantsRestaurant2.restaurantId
                    }
                }
            })
        }
    }
    
    func isNecessaryToUpdateRestaurants() -> Bool {
        if lastUpdateDate == nil {
            return true
        }
        if lastUpdateDate!.timeIntervalSince(Date()) < -3600 {
            return true
        }
        return false
    }
    
//    func setupUser(user: User?) {
//        //        self.user = user
//        //        updateProfileImage()
//    }
//
//    func updateProfileImage(user: User?) {
//        if user != nil {
//            if let imageName = user?.photo {
//                view.updateProfileImage(imageName: imageName)
//            }
//
//            view.updateProfileName(userName: "\(user?.firstName ?? "") \(user?.secondName ?? "")")
//        }
//    }
    
//    func updateProfileImage() {
//        //        if user != nil {
//        //            if let imageName = user?.photo {
//        //                view.updateProfileImage(imageName: imageName)
//        //            }
//        //        }
//        //        else {
//        ServerManager.shared.getProfile { [weak self] (isSuccess, getProfileResult, getProfileValue) in
//            if isSuccess {
//                if getProfileResult == .success, getProfileValue != nil {
//                    let user = getProfileValue?.user
//                    LoadedDataManager.shared.setupUser(user: user)
//                    self?.user = user
//                    self?.updateProfileImage(user: user)
//                }
//            }
//            else {
//                //                    self?.view.showErrorAlert(message: "Завантажити дані користувача не вдалося")
//            }
//        }
//        //        }
//    }
    
//    func profilePictureWasChanged() {
//        updateProfileImage()
//    }
    
    func loadActiveReservations() {
//        if UserDefaultsService.getAuthorizedInAccount() {
//            view?.showReservationsActivityIndicator(isLock: false)
//            ServerManager.shared.ordersActive(restaurantId: nil) { [weak self] (isSuccess, ordersActiveResult, ordersActiveValue) in
//                self?.view.hideReservationsActivityIndicator()
//                if isSuccess {
//                    if ordersActiveResult == .success, ordersActiveValue != nil {
//                        print("ordersActiveValue")
//                        print(ordersActiveValue)
//                        self?.reservationOrders = ordersActiveValue?.activeOrders ?? []
//                        self?.invitedOrders = ordersActiveValue?.invitedOrders ?? []
//                    }
//                    else {
//                        self?.view.showErrorAlert(message: "Сталася помилка при отриманні інформації про активні бронювання")
//                    }
//                }
//                else {
//                    self?.view.showErrorAlert(message: "Не вдалося отримати інформацію про активні бронювання")
//                }
//            }
//        }
    }
    
    func loadActiveDeliveries() {
//        if UserDefaultsService.getAuthorizedInAccount() {
//            view?.showActivityIndicator(isLock: false)
//            ServerManager.shared.deliveryOrdersActive(restaurantId: nil) { [weak self] (isSuccess, deliveryOrdersActiveResult, deliveryOrdersActiveValue) in
//                self?.view.hideActivityIndicator()
//                if isSuccess, deliveryOrdersActiveResult == .success, deliveryOrdersActiveValue != nil {
//                    print("deliveryOrdersActiveValue")
//                    print(deliveryOrdersActiveValue)
//                    self?.deliveries = deliveryOrdersActiveValue?.activeOrders ?? []
//                }
//                else {
//                    self?.view.showErrorAlert(message: "Не вдалося отримати інформацію про активні замовлення")
//                }
//            }
//        }
    }
    
    func loadFavourites() {
//        if UserDefaultsService.getAuthorizedInAccount() {
//            ServerManager.shared.favourites { [weak self] (isSuccess, favouritesResult, favouritesValue) in
//                self?.isFavouritesLoaded = true
//                if isSuccess, favouritesResult == .success {
//                    if favouritesValue != nil {
//
//                        self?.setupFavourites(favourites: favouritesValue!.favourites)
//                        self?.sortRestaurantsRestaurantIfCan()
//                        self?.updateRestaurantsFiltered()
//                    }
//                }
//                else {
//                    //
//                }
//            }
//        }
    }
    
//    func setupFavourites(favourites: [Favourite]) {
//        favouritesRestaurantIdsDict = favourites.reduce(into: [:]) {
//            $0[$1.restaurantId] = $1.restaurantId
//        }
//    }
}

extension RestaurantsPresenter {
    func takeCellsAmount() -> Int {
        var cellsAmount = invitedOrders.count + deliveries.count + reservationOrders.count
//        if isFavouritesLoaded {
            cellsAmount += restaurantsRestaurantsFiltered.count
//        }
        return cellsAmount
    }
    
    func takeCellInfo(index: Int) -> (cellType: RestaurantsTableViewCellType, restaurantsRestaurant: RestaurantsRestaurant?, order: Order?, invitedOrder: InvitedOrder?, deliveryOrder: DeliveryOrder?) {
        if index >= 0 && index < invitedOrders.count {
            let index1 = index
            let cellType: RestaurantsTableViewCellType = .reservation
            let invitedOrder = invitedOrders[index1]
            return (cellType: cellType, restaurantsRestaurant: nil, order: nil, invitedOrder: invitedOrder, deliveryOrder: nil)
        }
        else if index >= invitedOrders.count && index < invitedOrders.count + deliveries.count {
            let index1 = index - invitedOrders.count
            let cellType: RestaurantsTableViewCellType = .delivery
            let deliveryOrder = deliveries[index1]
            return (cellType: cellType, restaurantsRestaurant: nil, order: nil, invitedOrder: nil, deliveryOrder: deliveryOrder)
        }
        else if index >= invitedOrders.count+deliveries.count && index < invitedOrders.count+deliveries.count + reservationOrders.count {
            let index1 = index - invitedOrders.count - deliveries.count
            let cellType: RestaurantsTableViewCellType = .reservation
            let order = reservationOrders[index1]
            return (cellType: cellType, restaurantsRestaurant: nil, order: order, invitedOrder: nil, deliveryOrder: nil)
        }
        else {
            let index1 = index - invitedOrders.count - deliveries.count - reservationOrders.count
            let cellType: RestaurantsTableViewCellType = .restaurant
            let restaurantsRestaurant = restaurantsRestaurantsFiltered[index1]
            return (cellType: cellType, restaurantsRestaurant: restaurantsRestaurant, order: nil, invitedOrder: nil, deliveryOrder: nil)
        }
    }
    
    func takeCellHeight(index: Int) -> CGFloat {
        var baseRowHeight:CGFloat = 221.0
        
        if index >= 0 && index < invitedOrders.count {
            baseRowHeight = 80.0
        }
        else if index >= invitedOrders.count && index < invitedOrders.count + deliveries.count {
            baseRowHeight = 80.0
        }
        else if index >= invitedOrders.count+deliveries.count && index < invitedOrders.count+deliveries.count + reservationOrders.count {
            baseRowHeight = 80.0
        }
        else {
            baseRowHeight = 221.0
        }
        let scale = Scalable.scale
        let rowHeight = baseRowHeight * scale
        
        return rowHeight
    }
    
    func tableViewRowTapped(rowIndex: Int) {
        let index = rowIndex
        if index >= 0 && index < invitedOrders.count {
            let indexShifted = index
            let invitedOrder = invitedOrders[indexShifted]
//            view.showInvitedOrderVC(invitedOrder: invitedOrder)
        }
        else if index >= invitedOrders.count && index < invitedOrders.count+deliveries.count {
            let indexShifted = index - invitedOrders.count
            let deliveryOrder = deliveries[indexShifted]
//            view.showCheckViewController(deliveryOrder: deliveryOrder)
        }
        else if index >= invitedOrders.count+deliveries.count && index < invitedOrders.count+deliveries.count + reservationOrders.count {
            let indexShifted = index - invitedOrders.count - deliveries.count
            let order = reservationOrders[indexShifted]
//            view.showReservationConfirmVC(order: order)
        }
        else {
            let indexShifted = index - invitedOrders.count - deliveries.count - reservationOrders.count
            let restaurantsRestaurant = restaurantsRestaurantsFiltered[indexShifted]
            let restaurantId = restaurantsRestaurant.restaurantId
            //        loadRestaurant(restaurantId: restaurantId)
            
            
            var selectedRestaurant: Restaurant? = nil
            for restaurant1 in restaurants {
                if restaurant1.id == restaurantId {
                    selectedRestaurant = restaurant1
                }
            }
            if selectedRestaurant != nil {
                let restaurant = selectedRestaurant!
                let restaurantDict = restaurant.restaurantDict
                let restaurantId = restaurant.id
                let name = restaurant.name
                let scheduleInfo = restaurant.scheduleInfo
                let address = restaurant.address
                var restaurantsLocation: RestaurantsLocation? = nil
                if restaurant.name != nil, restaurant.latitude != nil, restaurant.longitude != nil {
                    restaurantsLocation = RestaurantsLocation(restaurantId: restaurant.id, latitude: restaurant.latitude!, longitude: restaurant.longitude!, restaurantName: restaurant.name!, restaurantAddress: address)
                }
                let phone = restaurant.phone
                let webAddress = restaurant.website
                let shortDescription = restaurant.shortDescription
                let description = restaurant.description
                let rating = restaurant.rating
                                
                var galleryImages:[String] = []
                if restaurant.gallery != nil {
                    for imageDict in restaurant.gallery! {
                        let imageName = imageDict["photo"] as? String
                        if imageName != nil {
                            galleryImages.append(imageName!)
                        }
                    }
                }
                let menuUrl:String? = restaurant.menuUrl
                let isMenuIncluded = restaurant.isMenuIncluded
                
//                print(restaurant.schedule)
//                print(restaurant.scheduleInfo)
                
                let restaurantRestaurant = RestaurantRestaurant(restaurantDict: restaurantDict,
                                                                restaurantId: restaurantId,
                                                                name: name,
                                                                scheduleInfo: scheduleInfo,
                                                                address: address,
                                                                restaurantsLocation: restaurantsLocation,
                                                                phone: phone,
                                                                webAddress: webAddress,
                                                                shortDescription: shortDescription,
                                                                description: description,
                                                                rating: rating,
                                                                galleryImages: galleryImages,
                                                                menuUrl: menuUrl,
                                                                isMenuIncluded: isMenuIncluded)
                
                view.showRestaurantVC(restaurantRestaurant: restaurantRestaurant)
            }
        }
    }
    
    func isFavourite(restaurantId: Int) -> Bool? {
        guard favouritesRestaurantIdsDict != nil else {
            return nil
        }
        let foundRestaurantId = favouritesRestaurantIdsDict![restaurantId]
        if foundRestaurantId != nil {
            return true
        }
        return false
    }
    
    func takeRestaurant(restaurantId: Int) -> Restaurant? {
        let restaurant = LoadedDataManager.shared.takeRestaurant(restaurantId: restaurantId)
        return restaurant
    }
    
}

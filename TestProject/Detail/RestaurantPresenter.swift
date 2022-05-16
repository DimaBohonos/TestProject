//
//  RestaurantPresenter.swift

import UIKit

protocol RestaurantPresenterView: class {
    func reloadRestaurantCollectionView()
    func setupBottomViewCornerRadius()
    func dismissVC()
    func setupRating(rating: Int?)
    func updateReviews(reviews: [RestaurantReview])
    func showRestaurantReviewDetailedVC()
    func showRestaurantReviewVC(restaurantId: Int)
    func showRestaurantAddressVC(restaurantsLocation: RestaurantsLocation)
    func showRestaurantEventVC(restaurantNews: RestaurantNews)
    func updateData()
    func updateFavouriteButton(isHidden: Bool?, isSelected: Bool?, isEnabled: Bool?)
    func showFullDescription()
    func hideDetailedButton()
    func showReservationVC(restaurantRestaurant: RestaurantRestaurant)
    func showDeliveryVC(restaurantRestaurant: RestaurantRestaurant)
    func showErrorAlert(message: String)
    func showCommentsActivityView(isLock: Bool)
    func hideCommentsActivityView()
    func showRestaurantExitView()
    func hideRestaurantExitViewWithoutAnimation()
    func showMenuVC(menuUrl: String)
    func showCheckoutVC(restaurant: Restaurant)
}

class RestaurantPresenter {
    weak var view: RestaurantPresenterView!
    var restaurantRestaurant: RestaurantRestaurant? = nil
    var restaurantCollectionItems:[RestaurantCollectionItem] = []
    var reviews: [RestaurantReview] = []
    var selectedReview: RestaurantReview?
    var news: [News] = []
    
    init(view: RestaurantPresenterView) {
        self.view = view
    }
    
    func viewDidLoaded() {
//        CartManager.shared.createNewCart()
        view.hideRestaurantExitViewWithoutAnimation()
        
        view.setupBottomViewCornerRadius()
        
        let rating = restaurantRestaurant?.rating
        view.setupRating(rating: rating)
        
        view.updateFavouriteButton(isHidden: true, isSelected: nil, isEnabled: nil)
        loadFavourites()
        showNews(news: nil)
        leadNews()
        setupComments(comments: [])
    }
    
    func viewWillAppeared() {
        view.updateData()
        loadComments()
    }
    
    func closeButtonTapped() {
//        let isFoodAddedToCart = CartManager.shared.isFoodAddedToCart()
//        if isFoodAddedToCart {
//            view.showRestaurantExitView()
//        }
//        else {
            view.dismissVC()
//        }
    }
    
    func reviewDetailButtonTapped(review: RestaurantReview) {
        self.selectedReview = review
        view.showRestaurantReviewDetailedVC()
    }
    
    func leaveReviewButtonTapped() {
        if let restaurantId = restaurantRestaurant?.restaurantId {
            view.showRestaurantReviewVC(restaurantId: restaurantId)
        }
    }
    
    func addressButtonTapped() {
        let restaurantId = restaurantRestaurant?.restaurantId
        let latitude = restaurantRestaurant?.restaurantsLocation?.latitude
        let longitude = restaurantRestaurant?.restaurantsLocation?.longitude
        let restaurantName = restaurantRestaurant?.name
        let restaurantAddress = restaurantRestaurant?.address
        
        guard restaurantId != nil, latitude != nil, longitude != nil, restaurantName != nil else {
            return
        }
        
        let restaurantsLocation = RestaurantsLocation(restaurantId: restaurantId!, latitude: latitude!, longitude: longitude!, restaurantName: restaurantName!, restaurantAddress: restaurantAddress)
        view.showRestaurantAddressVC(restaurantsLocation: restaurantsLocation)
    }
    
    func phoneButtonTapped() {
        guard let phone = restaurantRestaurant?.phone else {
            return
        }
        let phoneWithoutSpaces = phone.replacingOccurrences(of: " ", with: "")
        let phoneWithoutSpaces1 = phoneWithoutSpaces.trimmingCharacters(in: .whitespacesAndNewlines)
//        let components = phone.components(separatedBy: .whitespacesAndNewlines)
//        let phoneWithoutSpaces1 = components.filter { !$0.isEmpty }.joined()
        
        guard let phoneUrl = URL(string: "tel:" + phoneWithoutSpaces1) else {
            return
        }
        UIApplication.shared.open(phoneUrl)
    }
    
    func webAddressButtonTapped() {
        guard let webAddress = restaurantRestaurant?.webAddress else {
            return
        }
        guard let url = URL(string: webAddress) else {
            return
            
        }
        UIApplication.shared.open(url)
    }
    
    func collectionItemButtonTapped(newsIndex: Int) {
        let news1 = news[newsIndex]
        let restaurantNews = RestaurantNews(news: news1, restaurantName: restaurantRestaurant?.name)
        view.showRestaurantEventVC(restaurantNews: restaurantNews)
    }
    
    func setupRestaurant(restaurantRestaurant: RestaurantRestaurant) {
//        self.restaurantDetailed = restaurantDetailed
//        let restaurantsLocation = RestaurantsLocation(restaurantId: restaurantDetailed.id, latitude: restaurantDetailed.latitude, longitude: restaurantDetailed.longitude, restaurantName: restaurantDetailed.name, restaurantAddress: restaurantDetailed.address)
//        //TODO:It's wrong!!! rating: restaurantDetailed.ratingSort
//        self.restaurantRestaurant = RestaurantRestaurant(restaurantId: restaurantDetailed.id, name: restaurantDetailed.name, scheduleInfo: restaurantDetailed.scheduleInfo, address: restaurantDetailed.address, restaurantsLocation: restaurantsLocation, phone: restaurantDetailed.phone, webAddress: restaurantDetailed.website, shortDescription: restaurantDetailed.shortDescription, description: restaurantDetailed.description, rating: restaurantDetailed.ratingSort, galleryImages: restaurantDetailed.galleryImageNames ?? [])
        self.restaurantRestaurant = restaurantRestaurant
    }
    
    func loadComments() {
        guard let restaurantId = restaurantRestaurant?.restaurantId else {
            return
        }
        
        view.showCommentsActivityView(isLock: false)
        ServerManager.shared.comments(restaurantId: restaurantId) { [weak self] (isSuccess, commentsResult, commentsValue) in
            self?.view.hideCommentsActivityView()
            if commentsValue != nil {
                let comments = commentsValue!.comments
                self?.setupComments(comments: comments)
            }
            else {
                //TODO!!!
            }
        }
    }
    
    func setupComments(comments: [Comment]) {
        self.reviews = comments.map({ (comment) -> RestaurantReview in
            var userName = ""
            if comment.userFirstName != nil {
                userName = comment.userFirstName!
                if comment.userSecondName != nil {
                    userName = userName + " " + comment.userSecondName!
                }
            }
            else {
                userName = comment.userSecondName ?? ""
            }
            
            let review = RestaurantReview(reviewIdentifier: comment.commentId, rating: comment.stars, clientName: userName, reviewDate: comment.updatedAt, review: comment.text)
            return review
        })
        view.updateReviews(reviews: reviews)
    }
    
    func favouriteButtonTapped(isSelected: Bool) {
//        guard let restaurantId = restaurantRestaurant?.restaurantId else {
//            return
//        }
//        view.updateFavouriteButton(isHidden: nil, isSelected: nil, isEnabled: false)
//        if isSelected {
//            ServerManager.shared.deleteFavourite(restaurantId: restaurantId) { [weak self] (isSuccess, deleteFavouriteResult, deleteFavouriteValue) in
//                print("3")
//                self?.loadFavourites()
//            }
//        }
//        else {
//            ServerManager.shared.addFavourite(restaurantId: restaurantId) { [weak self](isSuccess, addFavouriteResult, addFavouriteValue) in
//                print("4")
//                self?.loadFavourites()
//            }
//        }
    }
    
    func loadFavourites() {
//        ServerManager.shared.favourites { [weak self] (isSuccess, favouritesResult, favouritesValue) in
//            if isSuccess, favouritesResult == .success {
//                if favouritesValue == nil {
//                    self?.view.updateFavouriteButton(isHidden: false, isSelected: false, isEnabled: true)
//                }
//                else {
//                    let favourites = favouritesValue!.favourites
//                    self?.updateFavouriteButton(favourites: favourites)
//                }
//
//                print("1")
//
//
//            }
//            else {
//                self?.view.updateFavouriteButton(isHidden: true, isSelected: nil, isEnabled: nil)
//            }
//        }
    }
    
//    func updateFavouriteButton(favourites: [Favourite]) {
//        guard let restaurantId = restaurantRestaurant?.restaurantId else {
//            view.updateFavouriteButton(isHidden: false, isSelected: false, isEnabled: true)
//            return
//        }
//        
//        var isFound = false
//        for favourite in favourites {
//            let restaurantId1 = favourite.restaurantId
//            if restaurantId1 == restaurantId {
//                isFound = true
//                break
//            }
//        }
//        view.updateFavouriteButton(isHidden: false, isSelected: isFound, isEnabled: true)
//    }
    
    func leadNews() {
        guard let restaurantId = restaurantRestaurant?.restaurantId else {
            return
        }
        ServerManager.shared.news(restaurantId: restaurantId) { [weak self] (isSuccess, newsResult, newsValue) in
            
            if newsValue != nil {
                let news = newsValue!.news
                
                if news.isEmpty {
                    self?.showNews(news: nil)
                }else{
                    self?.showNews(news: news)
                }
                
            }
            else {
                self?.showNews(news: nil)
            }
        }
    }
    
    func detailedButtonTapped() {
        view.showFullDescription()
        view.hideDetailedButton()
    }
    
    func menuButtonTapped() {
        let menuUrl = restaurantRestaurant?.menuUrl
        if menuUrl != nil {
            view.showMenuVC(menuUrl: menuUrl!)
        }
        else {
            view.showErrorAlert(message: "Меню не знайдено")
        }
    }
    
    func deliveryButtonTapped() {
        guard let restaurantRestaurant1 = restaurantRestaurant else {
            return
        }
        view.showDeliveryVC(restaurantRestaurant: restaurantRestaurant1)
    }
    
    func reservationButtonTapped() {
        if restaurantRestaurant != nil {
            view.showReservationVC(restaurantRestaurant: restaurantRestaurant!)
        }
        else {
            view.showErrorAlert(message: "Дані для бронювання завантажити не вдалося")
        }
    }
    
    func showNews(news: [News]?) {
        self.news = news ?? []
        view.reloadRestaurantCollectionView()
    }
    
    func reviewCouldBeLeft() {
        loadComments()
    }
    
    func exitButtonTapped() {
//        CartManager.shared.cleanCart()
        view.dismissVC()
    }
    
    func stayInRestaurantButtonTapped() {
        // Do nothing
    }
    
    func takeTotalSum() -> Double {
        let totalSum = 0.0//CartManager.shared.takeTotalSum()
        return totalSum
    }
    
    func orderButtonTapped() {
        let restaurant = self.restaurantRestaurant
        if restaurant != nil {
            
            let restaurantId = restaurant!.restaurantId
            guard restaurantId != nil else {
                return
            }
            guard let restaurant1 = LoadedDataManager.shared.takeRestaurant(restaurantId: restaurantId!) else { return
            }
            
//            print(restaurant1.restaurantDict["schedule"])
            
//            print(restaurant)
            
            view.showCheckoutVC(restaurant: restaurant1)
        }
        else {
            view.showErrorAlert(message: "Дані ресторану отримати не вдалося")
        }
    }
    
}

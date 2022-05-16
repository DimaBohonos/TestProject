//
//  RestaurantExitView.swift

import UIKit

protocol RestaurantExitViewDelegate: class {
    func exitButtonTapped()
    func stayInRestaurantButtonTapped()
}

class RestaurantExitView: ActionSheetView {
    @IBOutlet weak var dashLineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var exitButtonButton: UIButton!
    @IBOutlet weak var stayInRestaurantButton: UIButton!
    weak var delegate: RestaurantExitViewDelegate?
    
    func showView(delegate: RestaurantExitViewDelegate) {
        self.delegate = delegate
        super.showView()
        updateDashLineTopValue()
    }
    
    func updateDashLineTopValue() {
        let dashLineBaseTop: CGFloat = 23.0
        let dashLineTop = dashLineBaseTop * Scalable.scale
        self.dashLineTopConstraint.constant = dashLineTop
        layoutIfNeeded()
    }
    
    @IBAction func exitButtonClick(sender: UIButton) {
        delegate?.exitButtonTapped()
        print("11")
        hideView()
    }
    
    @IBAction func stayInRestaurantButtonClick(sender: UIButton) {
        delegate?.stayInRestaurantButtonTapped()
        print("22")
        hideView()
    }
}

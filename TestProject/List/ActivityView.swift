//
//  ActivityView.swift

import UIKit

class ActivityView: UIView {
    private weak var activityIndicatorView: UIActivityIndicatorView?
    private weak var lockView: UIView?
    private var activitiesRunned = 0
    
    func showActivityIndicator() {
        showActivityIndicator(isLockScreen: false, isDark: false)
    }
    
    func showActivityIndicator(isLockScreen: Bool) {
        showActivityIndicator(isLockScreen: isLockScreen, isDark: false)
    }
    
    func showActivityIndicator(isLockScreen: Bool, isDark: Bool) {
        if activitiesRunned == 0 {
            var backgroundColor = UIColor.clear
            if isDark {
                backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.05)
            }
            
            showLockView(isUserInteractionEnabled: isLockScreen, backgroundColor: backgroundColor)
            showActivityIndicatorView()
        }
        activitiesRunned += 1
    }
    
    func hideActivityIndicator() {
        activitiesRunned -= 1
        if activitiesRunned == 0 {
            hideActivityIndicatorView()
            hideLockView()
        }
    }
    
    private func showActivityIndicatorView() {
        if activityIndicatorView == nil {
            let activityIndicatorView1 = UIActivityIndicatorView(style: .gray)
            activityIndicatorView1.translatesAutoresizingMaskIntoConstraints = false
            addSubview(activityIndicatorView1)
            NSLayoutConstraint(item: activityIndicatorView1, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: activityIndicatorView1, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            self.activityIndicatorView = activityIndicatorView1
            self.layoutIfNeeded()
        }
        activityIndicatorView?.startAnimating()
    }
    
    private func hideActivityIndicatorView() {
        if activityIndicatorView != nil {
            activityIndicatorView?.stopAnimating()
            activityIndicatorView?.removeFromSuperview()
            activityIndicatorView = nil
        }
    }
    
    private func hideLockView() {
        if lockView != nil {
            lockView?.removeFromSuperview()
            lockView = nil
        }
    }
    
    private func showLockView(isUserInteractionEnabled: Bool, backgroundColor: UIColor) {
        if lockView == nil {
            let lockView1 = UIView()
            lockView1.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(lockView1)
            NSLayoutConstraint(item: lockView1, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: lockView1, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: lockView1, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: lockView1, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
            lockView1.backgroundColor = backgroundColor
            lockView1.isUserInteractionEnabled = isUserInteractionEnabled
            self.lockView = lockView1
            self.layoutIfNeeded()
        }
    }
}

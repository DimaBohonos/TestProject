//
//  ActionSheetView.swift

import UIKit

class ActionSheetView: UIView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var visualEffectView: UIVisualEffectView?
    @IBOutlet weak var darkView: UIView?
    
    private var containerAnimationTime = 0.7
    //    private var backgroundAnimationTime = 0.7
    
    private var runningAnimators: [UIViewPropertyAnimator] = []
    private var runningAnimatorsFractionCompletes: [CGFloat] = []
    private var currentState: LogicalState = .hidden
    private var panRecognizer: PanWithBeganStateGestureRecognizer? = nil
    
    private enum LogicalState {
        case showed
        case hidden
        
        var opposite: LogicalState {
            switch self {
            case .showed:
                return .hidden
            case .hidden:
                return .showed
            }
        }
    }
    
    var offsetVertical: CGFloat {
        let containerViewHeight = containerView.frame.height
        return containerViewHeight
    }
    
    func showView(isUserMoving: Bool = true) {
//        containerView.roundTopCorners()
        if isUserMoving {
            addPanRecognizerIfNecessary()
        }
        isHidden = false
        superview?.bringSubviewToFront(self)
        setupState(newState: .showed)
    }
    
    func hideView() {
        setupState(newState: .hidden)
    }
    
    private func setupState(newState: LogicalState) {
        guard newState != currentState else {
            return
        }
        
        if runningAnimators.isEmpty {
            // Add animators
            addAnimatorsIfNecessary(newState: newState)
        }
        else {
            // Change animators
            runningAnimators.forEach { (animator) in
                animator.isReversed = !animator.isReversed
            }
        }
    }
    
    private func addAnimatorsIfNecessary(newState: LogicalState) {
        guard runningAnimators.isEmpty else {
            return
        }
        let duration = containerAnimationTime
        let dampingRatio: CGFloat = 1.0
        
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio) { [weak self] in
            
            switch newState {
            case .showed:
                self?.containerViewBottomConstraint.constant = 0
            case .hidden:
                if let offsetVertical1 = self?.offsetVertical {
                    self?.containerViewBottomConstraint.constant = -offsetVertical1
                }
            }
            self?.layoutIfNeeded()
        }
        
        transitionAnimator.addCompletion { [weak self] (position) in
            switch position {
            case .start:
                self?.currentState = newState.opposite
            case .end:
                self?.currentState = newState
            case .current:
                break
            @unknown default:
                break
            }
            
            if let currentState = self?.currentState {
                switch currentState {
                case .showed:
                    self?.containerViewBottomConstraint.constant = 0
                case .hidden:
                    if let offsetVertical1 = self?.offsetVertical {
                        self?.containerViewBottomConstraint.constant = -offsetVertical1
                        self?.isHidden = true
                    }
                }
                self?.layoutIfNeeded()
            }
            
            self?.runningAnimators.removeAll()
        }
        
        transitionAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
        
//        if visualEffectView != nil, visualEffectView!.isHidden == false {
//            switch newState {
//            case .showed:
//                self.backgroundView.alpha = 1.0
//            case .hidden:
//                self.backgroundView.alpha = 0.0
//            }
//
//            let backgroundAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio) { [weak self] in
//                switch newState {
//                case .showed:
//                    self?.visualEffectView?.alpha = 0.35
//                    self?.darkView?.alpha = 0.22
//                case .hidden:
//                    self?.visualEffectView?.alpha = 0.0
//                    self?.darkView?.alpha = 0.0
//                }
//            }
//            backgroundAnimator.startAnimation()
//            runningAnimators.append(backgroundAnimator)
//        }
//        else {
                    let backgroundAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio) { [weak self] in
            
            switch newState {
            case .showed:
                self?.backgroundView.alpha = 1.0
            case .hidden:
                self?.backgroundView.alpha = 0.0
            }
//                    }
        }
        backgroundAnimator.startAnimation()
        runningAnimators.append(backgroundAnimator)
    }
    
    func hideWithoutAnimation() {
        containerViewBottomConstraint.constant = -offsetVertical
        layoutIfNeeded()
        isHidden = true
    }
    
    
    @IBAction private func closeButtonTapped(sender: UIButton) {
        hideView()
    }
    
    func addPanRecognizerIfNecessary() {
        guard panRecognizer == nil else {
            return
        }
        let panRecognizer1 = PanWithBeganStateGestureRecognizer()
        panRecognizer1.cancelsTouchesInView = false
        panRecognizer1.delegate = self
        panRecognizer1.addTarget(self, action: #selector(viewPanned(recognizer:)))
        containerView.addGestureRecognizer(panRecognizer1)
        self.panRecognizer = panRecognizer1
    }
    
    @objc func viewPanned(recognizer: PanWithBeganStateGestureRecognizer) {
        print("viewPanned")
        
        switch recognizer.state {
        case .began:
            addAnimatorsIfNecessary(newState: currentState.opposite)
            runningAnimators.forEach { (animator) in
                animator.pauseAnimation()
            }
            runningAnimatorsFractionCompletes = runningAnimators.map {
                $0.fractionComplete
            }
        case .changed:
            let translation = recognizer.translation(in: containerView)
            var fraction = -translation.y / offsetVertical
            if currentState == .showed {
                fraction = -fraction
            }
            if runningAnimators[0].isReversed {
                fraction = -fraction
            }
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = runningAnimatorsFractionCompletes[index] + fraction
            }
            
        case .ended:
            let yVelocity = recognizer.velocity(in: containerView).y
            //            let shouldClose = yVelocity > 0
            
            if yVelocity == 0 {
                break
            }
            
            if yVelocity == 0 {
                runningAnimators.forEach { (animator) in
                    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                }
                break
            }
            switch currentState {
            case .showed:
                if yVelocity < 0 {
                    runningAnimators.forEach { (animator) in
                        animator.isReversed = !animator.isReversed
                    }
                    currentState = currentState.opposite
                }
            case .hidden:
                if yVelocity > 0 {
                    runningAnimators.forEach { (animator) in
                        animator.isReversed = !animator.isReversed
                    }
                    currentState = currentState.opposite
                }
            }
            
            runningAnimators.forEach { (animator) in
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.0)
            }
            
        default:
            break
        }
    }
}

class PanWithBeganStateGestureRecognizer: UIPanGestureRecognizer {
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    //        if self.state == UIGestureRecognizer.State.began {
    //            return
    //        }
    //        super.touchesBegan(touches, with: event)
    //        self.state = UIGestureRecognizer.State.began
    //    }
}

extension ActionSheetView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        if touch.view is UITableView {
            return false
        }
        return true
    }
}

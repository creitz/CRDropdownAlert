//
//  CRDropdownAlert.swift
//  Pods
//
//  Created by Charles Reitz on 3/7/17.
//
//  Inspired by: https://github.com/cwRichardKim/RKDropdownAlert and https://github.com/startupthekid/DropdownAlert/
//

import UIKit
import pop

public protocol CRDropdownAlertDelegate {
    func dropdownAlertWasTapped(alert :CRDropdownAlert) -> Bool;
}

public class CRDropdownAlert: UIButton {
    
    // MARK: - Animation
    
    /**
     Animation types the dropdown can be presented with.
     
     - Basic:  Basic, simple animation.
     - Spring: Spring animation.
     - Custom: Custom animation.
     */
    public enum AnimationType {
        case Basic(timingFunction: CAMediaTimingFunction)
        case Spring(bounce: CGFloat, speed: CGFloat)
        case Custom(POPPropertyAnimation)
    }
    
    // MARK: - Views
    
    /// Alert title label.
    lazy var titleText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Alert message label.
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Defaults
    
    /**
     Class defaults.
     */
    struct Defaults {
        static var BackgroundColor           = UIColor.white
        static var TextColor                 = UIColor.black
        static var Title                     = "Default Title"
        static var Message                   = "Default message!"
        static var AnimationDuration: Double = 0.25
        static var Duration: Double          = 2
        static var TopPadding                = CGFloat(22)
        static var MiddlePadding             = CGFloat(4)
        static var BottomPadding             = CGFloat(10)
        static var Height: CGFloat           = 90
        static var TitleFont: UIFont         = UIFont.boldSystemFont(ofSize: Defaults.TitleFontSize)
        static var MessageFont: UIFont       = UIFont.systemFont(ofSize: Defaults.FontSize)
        static var TitleFontSize: CGFloat    = 16 {
            didSet {
                TitleFont = TitleFont.withSize(TitleFontSize)
            }
        }
        static var FontSize: CGFloat         = 14 {
            didSet {
                MessageFont = MessageFont.withSize(FontSize)
            }
        }
    }
    
    static let CRDropdownAlertDismissAllNotification = "CRDropdownAlertDismissAllNotification";
    
    var delegate :CRDropdownAlertDelegate?
    
    // MARK: - Initialization
    
    convenience public init() {
        self.init(frame: CGRect.zero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
}

public extension CRDropdownAlert {
    
    /**
     Show the dropdown alert.
     
     - parameter animationType:       The kind of animation that will be shown.
     - parameter title:           Dropdown title.
     - parameter message:         Dropdown message.
     - parameter backgroundColor: Background color of the dropdown.
     - parameter textColor:       Text color of the dropdown.
     - parameter duration:        How long the dropdown will be shown before it's automatically dismissmed.
     */
    class func showWithAnimation(animationType: AnimationType = .Basic(timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)),
                                 title           :String = Defaults.Title,
                                 message         :String = Defaults.Message,
                                 backgroundColor :UIColor = Defaults.BackgroundColor,
                                 textColor       :UIColor = Defaults.TextColor,
                                 duration        :Double = Defaults.Duration,
                                 delegate        :CRDropdownAlertDelegate? = nil) {
        
        // Ensure that everything happens on the main queue
        DispatchQueue.main.async {
            let windows = UIApplication.shared.windows.filter { $0.windowLevel == UIWindowLevelNormal && !$0.isHidden }
            guard let window = windows.first else {
                return
            }
            let dropdown = CRDropdownAlert()
            dropdown.translatesAutoresizingMaskIntoConstraints = false
            dropdown.titleText.text = title
            dropdown.messageLabel.text = message
            dropdown.titleText.textColor = textColor
            dropdown.messageLabel.textColor = textColor
            dropdown.messageLabel.numberOfLines = 0
            dropdown.backgroundColor = backgroundColor
            dropdown.delegate = delegate;
            
            // Construct a padding view that will cover the top of the dropdown in the case of a spring animation where it bounces past it's bounds
            let paddingView = UIView()
            paddingView.backgroundColor = backgroundColor
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            
            window.addSubview(dropdown)
            window.addSubview(paddingView)
            
            // Constraint that'll be animated
            let animatedConstraint = NSLayoutConstraint(item: dropdown, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1, constant: 0)
            
            // Add the drop downconstraint
            window.addConstraint(NSLayoutConstraint(item: dropdown, attribute: .left, relatedBy: .equal, toItem: window, attribute: .left, multiplier: 1, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: dropdown, attribute: .right, relatedBy: .equal, toItem: window, attribute: .right, multiplier: 1, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: dropdown, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: Defaults.Height))
            window.addConstraint(animatedConstraint)
            
            // Add the padding view constraints
            window.addConstraint(NSLayoutConstraint(item: paddingView, attribute: .width, relatedBy: .equal, toItem: dropdown, attribute: .width, multiplier: 1, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: paddingView, attribute: .height, relatedBy: .equal, toItem: dropdown, attribute: .height, multiplier: 1, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: paddingView, attribute: .centerX, relatedBy: .equal, toItem: dropdown, attribute: .centerX, multiplier: 1, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: paddingView, attribute: .bottom, relatedBy: .equal, toItem: dropdown, attribute: .top, multiplier: 1, constant: 0))
            
            window.layoutIfNeeded()
            
            let titleFrame = dropdown.titleText.frame;
            let titleHeight = titleFrame.size.height;
            let messageFrame = dropdown.messageLabel.frame;
            let messageHeight = messageFrame.size.height;
            
            let contentHeight = Int(messageHeight) + Int(titleHeight);
            
            let animation = self.popAnimationForAnimationType(animationType: animationType)
            animation.toValue = contentHeight + Int(Defaults.TopPadding + Defaults.MiddlePadding + Defaults.BottomPadding);
            animatedConstraint.pop_add(animation, forKey: "show-dropdown")
            
            dropdown.perform(#selector(dismiss), with: nil, afterDelay: duration + Defaults.AnimationDuration)
        }
    }
    
    /**
     Dismiss the dropdown.
     
     - parameter dropdown: Dropdown object to dismiss.
     */
    private class func dismissAlert(dropdown: CRDropdownAlert) {
        guard let window = dropdown.superview as? UIWindow else {
            return
        }
        let constraints = window.constraints.filter { ($0.firstItem === dropdown || $0.secondItem === dropdown) && ($0.firstAttribute == .bottom || $0.secondAttribute == .bottom) && $0.isActive }
        guard let animatedConstraint = constraints.first else {
            return
        }
        DispatchQueue.main.async {
            let dismissAnimation = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            dismissAnimation?.toValue = -Defaults.Height
            dismissAnimation?.duration = Defaults.AnimationDuration
            animatedConstraint.pop_add(dismissAnimation, forKey: "dropdown-dismiss")
            DispatchQueue.main.asyncAfter(deadline: .now() + Defaults.AnimationDuration) {
                dropdown.removeFromSuperview();
            }
        }
    }
    
    public class func dismissAll() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CRDropdownAlertDismissAllNotification), object: nil);
    }
    
    /**
     Dismiss the dropdown.
     */
    public func dismiss() {
        type(of: self).dismissAlert(dropdown: self)
    }
}

// MARK: - Helpers
private extension CRDropdownAlert {
    
    /**
     Construct a full `POPAnimation` object for the corresponding animation types.
     
     - parameter animationType: `AnimationType` object that describes the desired animation.
     
     - returns: `POPPropertyAnimation` object.
     */
    class func popAnimationForAnimationType(animationType: AnimationType) -> POPPropertyAnimation {
        switch animationType {
        case let .Basic(timingFunction):
            let animation = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            animation?.duration = Defaults.AnimationDuration
            animation?.timingFunction = timingFunction
            return animation!
        case let .Spring(bounce, speed):
            let animation = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            animation?.springBounciness = bounce
            animation?.springSpeed = speed
            return animation!
        case let .Custom(a):
            return a
        }
    }
}


// MARK: Default Modifiers
public extension CRDropdownAlert {
    
    public class var defaultBackgroundColor: UIColor {
        get { return Defaults.BackgroundColor }
        set { Defaults.BackgroundColor = newValue }
    }
    
    public class var defaultTextColor: UIColor {
        get { return Defaults.TextColor }
        set { Defaults.TextColor = newValue }
    }
    
    public class var defaultTitle: String {
        get { return Defaults.Title }
        set { Defaults.Title = newValue }
    }
    
    public class var defaultMessage: String {
        get { return Defaults.Message }
        set { Defaults.Message = newValue }
    }
    
    public class var defaultAnimationDuration: Double {
        get { return Defaults.AnimationDuration }
        set { Defaults.AnimationDuration = newValue }
    }
    
    public class var defaultDuration: Double {
        get { return Defaults.Duration }
        set { Defaults.Duration = newValue }
    }
    
    public class var defaultHeight: CGFloat {
        get { return Defaults.Height }
        set { Defaults.Height = newValue }
    }
    
    public class var defaultTitleFont: UIFont {
        get { return Defaults.TitleFont }
        set { Defaults.TitleFont = newValue }
    }
    
    public class var defaultMessageFont: UIFont {
        get { return Defaults.MessageFont }
        set { Defaults.MessageFont = newValue }
    }
    
    public class var defaultFontSize: CGFloat {
        get { return Defaults.FontSize }
        set { Defaults.FontSize = newValue }
    }
}

// MARK: - Setup
private extension CRDropdownAlert {
    
    /**
     Common initialization function.
     */
    func commonInit() {
        self.titleText.font = Defaults.TitleFont
        self.messageLabel.font = Defaults.MessageFont
        
        self.addSubview(self.titleText)
        self.addSubview(self.messageLabel)
        self.setupConstraints()
        
        self.addTarget(self, action: #selector(CRDropdownAlert.viewWasTapped(alertView:)), for: .touchUpInside);
        
        NotificationCenter.default.addObserver(self, selector: #selector(CRDropdownAlert.dismiss), name: NSNotification.Name(rawValue: CRDropdownAlert.CRDropdownAlertDismissAllNotification), object: nil);
    }
    
    @objc
    private func viewWasTapped(alertView :UIView) {
        
        if let delegate = self.delegate {
            if delegate.dropdownAlertWasTapped(alert: self) {
                self.dismiss();
            }
        } else {
            self.dismiss();
        }
    }
    
    /**
     Setup the constraints for the dropdown's labels.
     */
    private func setupConstraints() {
        self.addConstraint(NSLayoutConstraint(item: self.titleText, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.titleText, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.titleText, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel, attribute: .top, relatedBy: .equal, toItem: self.titleText, attribute: .bottom, multiplier: 1, constant: Defaults.MiddlePadding))
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -Defaults.BottomPadding))
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0))
        
        self.layoutIfNeeded()
    }
}

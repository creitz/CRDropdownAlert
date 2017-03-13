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
    
    func commonInit() {
        
        self.addTarget(self, action: #selector(CRDropdownAlert.viewWasTapped(alertView:)), for: .touchUpInside);
        
        NotificationCenter.default.addObserver(self, selector: #selector(CRDropdownAlert.dismiss), name: NSNotification.Name(rawValue: CRDropdownAlert.CRDropdownAlertDismissAllNotification), object: nil);
    }
    
    fileprivate func addToWindow(_ window :UIWindow) {
        
        // Construct a padding view that will cover the top of the dropdown in the case of a spring animation where it bounces past its bounds
        let paddingView = UIView()
        paddingView.backgroundColor = backgroundColor
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        
        window.addSubview(self)
        window.addSubview(paddingView)
        
        // Add the drop downconstraint
        window.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: window, attribute: .left, multiplier: 1, constant: 0))
        window.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: window, attribute: .right, multiplier: 1, constant: 0))
        window.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: self.getHeight()))
        
        // Add the padding view constraints
        window.addConstraint(NSLayoutConstraint(item: paddingView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))
        window.addConstraint(NSLayoutConstraint(item: paddingView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0))
        window.addConstraint(NSLayoutConstraint(item: paddingView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        window.addConstraint(NSLayoutConstraint(item: paddingView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
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
    
    fileprivate func getHeight() -> CGFloat {
        assert(false, "Subclasses need to override getHeight");
        return 0;
    }
    
}

private class CRTextDropdownAlert : CRDropdownAlert {
    
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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init(title :String, message :String, backgroundColor :UIColor, textColor :UIColor, delegate :CRDropdownAlertDelegate?) {
        
        self.init();
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.delegate = delegate;
        
        self.titleText.text = title
        self.messageLabel.text = message
        self.titleText.textColor = textColor
        self.messageLabel.textColor = textColor
        self.messageLabel.numberOfLines = 0
        self.backgroundColor = backgroundColor
    }
    
    override func commonInit() {
        super.commonInit();
        
        self.titleText.font = Defaults.TitleFont
        self.messageLabel.font = Defaults.MessageFont
        
        self.addSubview(self.titleText)
        self.addSubview(self.messageLabel)
        
        self.setupConstraints()
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
    
    fileprivate override func getHeight() -> CGFloat {
        
        let titleFrame = self.titleText.frame;
        let titleHeight = titleFrame.size.height;
        let messageFrame = self.messageLabel.frame;
        let messageHeight = messageFrame.size.height;
        
        return Defaults.TopPadding + titleHeight + Defaults.MiddlePadding + messageHeight + Defaults.BottomPadding;
    }
}

private class CRCustomDropdownAlert : CRDropdownAlert {
    
    private var contentView :UIView? = nil;
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init(view :UIView, backgroundColor :UIColor, delegate :CRDropdownAlertDelegate?) {
        
        self.init();
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.delegate = delegate;
        self.contentView = view;
        
        self.addSubview(view);
        self.backgroundColor = backgroundColor;
        
        setupConstraints(view: view);
    }
    
    private func setupConstraints(view :UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -Defaults.BottomPadding));
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0));
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        self.layoutIfNeeded();
    }
    
    override func getHeight() -> CGFloat {
        
        if let contentView = self.contentView {
            return Defaults.TopPadding + contentView.frame.size.height + Defaults.BottomPadding;
        }
        
        return 0;
    }
    
}

public extension CRDropdownAlert {
    
    /**
     Show the dropdown alert. This should be called from the main thread.
     
     - parameter animationType:   The kind of animation that will be shown.
     - parameter view:            The custom view for the dropwdown.
     - parameter backgroundColor: Background color of the dropdown.
     - parameter duration:        How long the dropdown will be shown before it's automatically dismissmed.
     */
    static func show(animationType: AnimationType = .Basic(timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)),
                     view            :UIView,
                     backgroundColor :UIColor = Defaults.BackgroundColor,
                     duration        :Double = Defaults.Duration,
                     window          :UIWindow? = nil,
                     delegate        :CRDropdownAlertDelegate? = nil) -> CRDropdownAlert? {
        
        var theWindow = window;
        
        if theWindow == nil {
            theWindow = getMainWindow();
            if theWindow == nil {
                return nil;
            }
        }
        
        let dropdown = CRCustomDropdownAlert.init(view: view, backgroundColor: backgroundColor, delegate: delegate);
        show(dropdownAlert: dropdown, window: theWindow!, animationType: animationType, duration: duration);
        
        return dropdown;
    }
    
    /**
     Show the dropdown alert. This should be called from the main thread.
     
     - parameter animationType:   The kind of animation that will be shown.
     - parameter title:           Dropdown title.
     - parameter message:         Dropdown message.
     - parameter backgroundColor: Background color of the dropdown.
     - parameter textColor:       Text color of the dropdown.
     - parameter duration:        How long the dropdown will be shown before it's automatically dismissmed.
     */
    static func show(animationType: AnimationType = .Basic(timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)),
                     title           :String = Defaults.Title,
                     message         :String = Defaults.Message,
                     backgroundColor :UIColor = Defaults.BackgroundColor,
                     textColor       :UIColor = Defaults.TextColor,
                     duration        :Double = Defaults.Duration,
                     window          :UIWindow? = nil,
                     delegate        :CRDropdownAlertDelegate? = nil) -> CRDropdownAlert? {
        
        var theWindow = window;
        
        if theWindow == nil {
            theWindow = getMainWindow();
            if theWindow == nil {
                return nil;
            }
        }
        
        let dropdown = CRTextDropdownAlert.init(title: title, message: message, backgroundColor: backgroundColor, textColor: textColor, delegate: delegate);
        show(dropdownAlert: dropdown, window: theWindow!, animationType: animationType, duration: duration);
        
        return dropdown;
    }
    
    private static func show(dropdownAlert :CRDropdownAlert, window :UIWindow, animationType :AnimationType, duration :Double) {
        
        dropdownAlert.addToWindow(window);
        
        // Constraint that'll be animated
        let animatedConstraint = NSLayoutConstraint(item: dropdownAlert, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1, constant: 0);
        window.addConstraint(animatedConstraint);
        
        window.layoutIfNeeded();
        
        let height = dropdownAlert.getHeight();
        
        let animation = self.popAnimationForAnimationType(animationType: animationType);
        animation.toValue = height;
        animatedConstraint.pop_add(animation, forKey: "show-dropdown");
        
        dropdownAlert.perform(#selector(dismiss), with: nil, afterDelay: duration + Defaults.AnimationDuration)
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
            dismissAnimation?.toValue = -dropdown.getHeight();
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
    
    private class func getMainWindow() -> UIWindow? {
        
        let windows = UIApplication.shared.windows.filter { $0.windowLevel == UIWindowLevelNormal && !$0.isHidden }
        if let window = windows.first {
            return window;
        }
        return nil;
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

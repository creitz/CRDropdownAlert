# CRDropdownAlert

A clean, customizable Swift alternative to [RKDropdownAlert](https://github.com/cwRichardKim/RKDropdownAlert) and [DropdownAlert](https://github.com/startupthekid/DropdownAlert) that supports custom views. Much credit to each of their contributors, especially DropdownAlert.

## Overview

This project was inspired by [RKDropdownAlert](https://github.com/cwRichardKim/RKDropdownAlert) and [DropdownAlert](https://github.com/startupthekid/DropdownAlert).  It combines the best of each of them. 

* Written in Swift 3 (at the time of writing this, DropdownAlert had not yet been updated to Swift 3)
* Responsive      - Uses Autolayout
* Touch Activated - Supports delegates for responding to user clicks
* Supports custom views - Don't restrict yourself to a title and a message. You can create a custom view and hand it off to CRDropdownAlert.

## Usage

`CRDropdownAlert` comes with 3 animation types, `Basic`, `Spring`, and `Custom`:

```swift

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
```

Example (the args besides title and message are optional):

```swift
CRDropdownAlert.showWithAnimation(.Basic(timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)), title: "New Message", message: "I'm on my way!", duration: Double(3))
```

### Customization

The following class level properties are customizable:

```swift
class var defaultBackgroundColor: UIColor
class var defaultTextColor: UIColor 
class var defaultTitle: String
class var defaultMessage: String
class var defaultAnimationDuration: Double
class var defaultDuration: Double
class var defaultTitleFont: UIFont
class var defaultMessageFont: UIFont
class var defaultFontSize: CGFloat
```

DropdownAlert claims that the size of the alert will be always be greater than or equal to the size of your content, but I've found that to not always be the case. CRDropdownAlert fixes this by allowing message line wrapping. Some default layout improvements have also been made, including spacing, borders, and bolding.

To customize a particular attribute:

```swift
DropdownAlert.defaultHeight = 110
DropdownAlert.defaultBackgroundColor = UIColor.blueColor()
```

To use a custom view rather than the built-in title and message labels (the args besides view are optional):

```swift
CRDropdownAlert.show(animationType: .Spring(bounce: 0.5, speed: 0.5), view: customView, backgroundColor: .white, duration: Double(3));
```

For example, this is how I create a progress bar in a CRDropdownAlert:

```swift
let parentView = UIView.init();
let progressView = UIProgressView(progressViewStyle: .default);

progressView.translatesAutoresizingMaskIntoConstraints = false;

parentView.addConstraint(NSLayoutConstraint(item: progressView, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1, constant: 0));
parentView.addConstraint(NSLayoutConstraint(item: progressView, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1, constant: 0));
parentView.addConstraint(NSLayoutConstraint(item: progressView, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 10));
parentView.addConstraint(NSLayoutConstraint(item: progressView, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: -10));
parentView.addSubview(progressView);

CRDropdownAlert.show(animationType: .Spring(bounce: 0.5, speed: 0.5), view: parentView, backgroundColor: .black, duration: Double(3));

```
CRDropdownalert uses autolayout to determine sizing. When you pass a custom view to show(), the view will be centered horizontally and given some padding around the edges. You will probably need to set progressView.translatesAutoresizingMaskIntoConstraints to false. translatesAutoresizingMaskIntoConstraints will automatically be set to false for you on the customView.

You can also pass a custom window from which the dropdown should be launched. 

## Support

Feel free to open an issue or issue a PR! Check out the [contribution guide](CRDropdownAlert/CHANGELOG.md) for more info.


## Installation

CRDropdownAlert is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CRDropdownAlert"
```

## Author

Charles Reitz, cgreitz@gmail.com.


## License

CRDropdownAlert is available under the MIT license. See the LICENSE file for more info.

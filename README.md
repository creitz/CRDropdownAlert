# UNDER CONSTRUCTION

# CRDropdownAlert

A clean, customizable Swift alternative to [RKDropdownAlert](https://github.com/cwRichardKim/RKDropdownAlert) and [DropdownAlert](https://github.com/startupthekid/DropdownAlert). Much credit to each of their contributors, especially DropdownAlert.

## Overview

This project was inspired by [RKDropdownAlert](https://github.com/cwRichardKim/RKDropdownAlert) and [DropdownAlert](https://github.com/startupthekid/DropdownAlert).  It combines the best of each of them. 

* Written in Swift 3 (at the time of writing this, DropdownAlert had not yet been updated to Swift 3)
* Responsive      - Uses Autolayout
* Touch Activated - Supports delegates for responding to user clicks

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

Example:

```swift
CRDropdownAlert.showWithAnimation(.Basic(timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)), title: "New Message", message: "I'm on my way!", duration: 3)
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
class var defaultHeight: CGFloat
class var defaultTitleFont: UIFont
class var defaultMessageFont: UIFont
class var defaultFontSize: CGFloat
```

DropdownAlert claims that the size of the alert will be always be greater than or equal to the size of your content, but I've found that  to not always be the case. CRDropdownAlert fixes this by allowing message line wrapping. Some default layout improvements have also been made, including spacing, borders, and bolding.

To customize a particular attribute:

```swift
DropdownAlert.defaultHeight = 110
DropdownAlert.defaultBackgroundColor = UIColor.blueColor()
```

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

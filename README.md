# FaveButton

[![CocoaPods](https://img.shields.io/cocoapods/p/FaveButton.svg)](https://cocoapods.org/pods/FaveButton)
[![CocoaPods](https://img.shields.io/cocoapods/v/FaveButton.svg)](https://cocoapods.org/pods/FaveButton)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/janselv/fave-button)
[![codebeat badge](https://codebeat.co/badges/580517f8-efc8-4d20-89aa-900531610144)](https://codebeat.co/projects/github-com-janselv-fave-button-master)
[![Build Status](https://travis-ci.org/janselv/fave-button.svg?branch=master)](https://travis-ci.org/janselv/fave-button)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-green.svg)](https://developer.apple.com/swift/)

Favorite Animated Button written in Swift


![preview](https://github.com/janselv/fave-button/blob/master/fave-button1.gif)


## Requirements

- iOS 8.0+
- Xcode 9+

## Installation

For manual instalation, drag Source folder into your project.

os use [CocoaPod](https://cocoapods.org) adding this line to you `Podfile`:

```ruby
pod 'FaveButton'
```

for [Carthage](https://github.com/Carthage/Carthage) users, add this line to you `Cartfile`

```ruby
github "xhamr/fave-button"
```


## Usage

#### With storyboard or xib files

1) Create a Button that inherits from `FaveButton`

2) Add Image for a `Normal` state

3) Set the `IBOutlet` delegate property to a subclass of `FaveButtonDelegate`

4) ___Optional___ manipulate porperties to change button settings

```swift
@IBInspectable public var normalColor:     UIColor
@IBInspectable public var selectedColor:   UIColor
@IBInspectable public var dotFirstColor:   UIColor
@IBInspectable public var dotSecondColor:  UIColor
@IBInspectable public var circleFromColor: UIColor
@IBInspectable public var circleToColor:   UIColor
```
 
 5) ___Optional___ respond to delegate methods

 ```swift
func faveButton(faveButton: FaveButton, didSelected selected: Bool)    
func faveButtonDotColors(faveButton: FaveButton) -> [DotColors]?     
 ```


#### In Code

```swift
let faveButton = FaveButton(
    frame: CGRect(x:200, y:200, width: 44, height: 44),
    faveIconNormal: UIImage(named: "heart")
)
faveButton.delegate = self
view.addSubview(faveButton)
```

## Manipulating dot colors

If you want differents colors for dots like `Twitter’s Heart Animation` use the delegate method for the button you want.

```swift
func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]? {
   if faveButton == myFaveButton{
	 // return dot colors
   }
   return nil
}
```

in [FaveButtonDemo](https://github.com/janselv/fave-button/tree/master/FaveButtonDemo) you will find a set of color to cause dots appear like this:

![preview](https://github.com/janselv/fave-button/blob/master/fave-button2.gif)



## Credits

FaveButton was inspired by Twitter’s Like Heart Animation within their [App](https://itunes.apple.com/us/app/twitter/id333903271)


## License

FaveButton is released under the MIT license.












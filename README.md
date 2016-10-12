BtownToolkit
======================================
![platforms](https://img.shields.io/badge/platforms-iOS-333333.svg)

## About BtownToolkit
This toolkit tries to simplify the lives for app developers by supplying easy to use and feature-rich components and tools that we all need in our everyday code creation. The aim is to continuously add on more components and features to the toolkit as soon as a need for something new is discovered.

## Requirements
* Xcode 8.0
* Swift 3.0
* iOS 9.0+

## Example
Some code examples can be found in the example project that comes with this project. Here is a short overview of some of the tools available.

### AlertView
AlertView is using built in logic from UIAlertController but you dont need to present it from another UIViewController. You can just call '.show()' on the AlertView and it will be presented on top of other content in its own UIWindow.
```
let alertView = AlertView(title: "title", message: "message")
alertView.addTextField(identifier: "TextTield1") { (textField) in
    textField.font = UIFont.boldSystemFont(ofSize: 16)
    textField.textColor = UIColor.red
}
alertView.addAction(title: "Delete", actionType: .destructive, actionCallback: nil) {
    print("Destructive Action")
}
alertView.addAction(title: "Normal", actionType: .normal) {
    print("Normal Action")
}
alertView.addAction(title: "Cancel", actionType: .cancel) {
    print("Cancel Action")
}
alertView.wasDismissedClosure = {
    print("AlertView did disappear")
}
alertView.show()
```

### ImageView-Helpers
ScrollableImageView is a view where you can set an image and then pinch to zoom in that image and scroll around.
ImageCropSelectionView is a ScrollableImageView with a round selection area, from which you can get the contained image. It's usable for picking user profile images for example. 
```
let scrollableImageView = ScrollableImageView()
scrollableImageView.image = UIImage(named: "ImageExample")
scrollableImageView.setImageZoomScaleToAspectFitViewSize()
scrollableImageView.centerImageInView()

let imageCropSelectionView = ImageCropSelectionView()
imageCropSelectionView.image = UIImage(named: "ImageExample")
...
let userImage = imageCropSelectionView.croppedSelectionImage()
```

## Installation
BtownToolkit is available through [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
pod 'BtownToolkit'
end
```
Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:
```
$ pod install
```
**:warning: To use CocoaPods with Xcode 8.0 and Swift 3.0, you might need to add the following lines at the bottom of your podfile: :warning:**
```
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
```

## Author

Robert Magnusson, robert@btown.se

## License

BtownToolkit is available under the MIT license. See the LICENSE file for more info.

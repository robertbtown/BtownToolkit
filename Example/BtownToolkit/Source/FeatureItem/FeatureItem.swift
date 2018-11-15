//
//  FeatureItem.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2016-09-26.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

enum FeatureItem {
    case alertView
    case actionSheet
    case scrollableImageView
    case imageCropSelectionView
    case loadingView
}

extension FeatureItem {
    var name: String {
        switch self {
        case .alertView:
            return "AlertView"
        case .actionSheet:
            return "ActionSheet"
        case .scrollableImageView:
            return "ScrollableImageView"
        case .imageCropSelectionView:
            return "ImageCropSelectionView"
        case .loadingView:
            return "LoadingView"
        }
    }
    var shortInfoText: String {
        switch self {
        case .alertView:
            return "Simplyfies UIAlertController."
        case .actionSheet:
            return "Simplyfies UIAlertController."
        case .scrollableImageView:
            return "Zoomable and scrollable ImageView."
        case .imageCropSelectionView:
            return "ScrollableImageView with selection area."
        case .loadingView:
            return "A nice looking loading view"
        }
    }

    private var storyboardId: String {
        switch self {
        case .alertView:
            return "AlertViewScreen"
        case .actionSheet:
            return "ActionSheetScreen"
        case .scrollableImageView:
            return "ScrollabelImageViewScreen"
        case .imageCropSelectionView:
            return "ImageCropSelectionViewScreen"
        case .loadingView:
            return "LoadingViewScreen"
        }
    }
    var viewController: UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.storyboardId)
    }
}

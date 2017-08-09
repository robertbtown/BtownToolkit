//
//  FeatureItem.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2016-09-26.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

enum FeatureItem {
    case AlertView
    case ActionSheet
    case ScrollableImageView
    case ImageCropSelectionView
}

extension FeatureItem {
    var name: String {
        switch self {
        case .AlertView:
            return "AlertView"
        case .ActionSheet:
            return "ActionSheet"
        case .ScrollableImageView:
            return "ScrollableImageView"
        case .ImageCropSelectionView:
            return "ImageCropSelectionView"
        }
    }
    var shortInfoText: String {
        switch self {
        case .AlertView:
            return "Simplyfies UIAlertController."
        case .ActionSheet:
            return "Simplyfies UIAlertController."
        case .ScrollableImageView:
            return "Zoomable and scrollable ImageView."
        case .ImageCropSelectionView:
            return "ScrollableImageView with selection area."
        }
    }
    
    private var storyboardId: String {
        switch self {
        case .AlertView:
            return "AlertViewScreen"
        case .ActionSheet:
            return "ActionSheetScreen"
        case .ScrollableImageView:
            return "ScrollabelImageViewScreen"
        case .ImageCropSelectionView:
            return "ImageCropSelectionViewScreen"
        }
    }
    var viewController: UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.storyboardId)
    }
}

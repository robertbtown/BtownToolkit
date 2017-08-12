//
//  StartViewModel.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 19/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct StartViewModel {
    
    let featureItems: [FeatureItem]
    var didSelectListFeatureClosure: ((FeatureItem) -> ())?
    
    init() {
        featureItems = [
            .AlertView,
            .ActionSheet,
            .ScrollableImageView,
            .ImageCropSelectionView,
            .LoadingView
        ]
    }
    
    func featureItem(atIndexPath: IndexPath) -> FeatureItem {
        guard atIndexPath.row < featureItems.count else {
            return .AlertView
        }
        return featureItems[atIndexPath.row]
    }
}

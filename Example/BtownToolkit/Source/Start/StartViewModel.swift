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
    var didSelectListFeatureClosure: ((FeatureItem) -> Void)?

    init() {
        featureItems = [
            .alertView,
            .actionSheet,
            .scrollableImageView,
            .imageCropSelectionView,
            .loadingView
        ]
    }

    func featureItem(atIndexPath: IndexPath) -> FeatureItem {
        guard atIndexPath.row < featureItems.count else {
            return .alertView
        }
        return featureItems[atIndexPath.row]
    }
}

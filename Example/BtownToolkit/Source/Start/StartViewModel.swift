//
//  StartViewModel.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 19/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct StartViewModel {
    
    private(set) var featureItems = [FeatureItem]()
    var didSelectListFeatureClosure: ((FeatureItem) -> ())?
    
    init() {
        setupFeatureItems()
    }
    
    mutating private func setupFeatureItems() {
        let featureItem = FeatureItem.AlertView
        featureItems.append(featureItem)
    }
    
    func featureItem(atIndexPath: IndexPath) -> FeatureItem {
        guard atIndexPath.row < featureItems.count else {
            return .AlertView
        }
        return featureItems[atIndexPath.row]
    }
}

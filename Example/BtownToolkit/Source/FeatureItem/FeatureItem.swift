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
}

extension FeatureItem {
    var name: String {
        switch self {
        case .AlertView:
            return "AlertView"
        }
    }
    var shortInfoText: String {
        switch self {
        case .AlertView:
            return "Simplyfies UIAlertController."
        }
    }
    private var storyboardId: String {
        switch self {
        case .AlertView:
            return "SomeID"
        }
    }
    var viewController: UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.storyboardId)
    }
}

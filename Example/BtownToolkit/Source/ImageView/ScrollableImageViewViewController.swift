//
//  ScrollableImageViewViewController.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2016-10-11.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import BtownToolkit

class ScrollableImageViewViewController: UIViewController {
    
    @IBOutlet var scrollableImageView: ScrollableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ScrollabelImageView"

        scrollableImageView.image = UIImage(named: "BigImageExample")
        scrollableImageView.setImageZoomScaleToAspectFitViewSize()
        scrollableImageView.centerImageInView()
    }
}

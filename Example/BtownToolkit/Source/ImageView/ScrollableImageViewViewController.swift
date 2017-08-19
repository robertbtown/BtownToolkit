//
//  ScrollableImageViewViewController.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2016-10-11.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import BtownToolkit

class ScrollableImageViewViewController: UIViewController, BTWLocalize {

    @IBOutlet var scrollableImageView: ScrollableImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Localized title string
        title = btwTypeString("Title")

        scrollableImageView.image = UIImage(named: "BigImageExample")
        scrollableImageView.setImageZoomScaleToAspectFitViewSize()
        scrollableImageView.centerImageInView()
    }
}

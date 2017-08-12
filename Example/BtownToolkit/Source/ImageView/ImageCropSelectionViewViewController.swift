//
//  ImageCropSelectionViewViewController.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2016-10-11.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import BtownToolkit

class ImageCropSelectionViewViewController: UIViewController, BTWLocalize {

    @IBOutlet var imageCropSelectionView: ImageCropSelectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Localized title string
        title = btwClassString("Title")

        imageCropSelectionView.image = UIImage(named: "BigImageExample")
    }
}

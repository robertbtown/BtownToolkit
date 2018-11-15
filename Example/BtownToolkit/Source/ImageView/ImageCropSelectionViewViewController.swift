//
//  ImageCropSelectionViewViewController.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2016-10-11.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

// swiftlint:disable line_length

import UIKit
import BtownToolkit

class ImageCropSelectionViewViewController: UIViewController, BTWLocalize {

    @IBOutlet var imageCropSelectionView: ImageCropSelectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Localized title string
        title = btwTypeString("Title")

        imageCropSelectionView.image = UIImage(named: "BigImageExample")

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Get image", style: .plain, target: self, action: #selector(getPhotoAction))
    }

    @objc private func getPhotoAction() {
        guard let image = imageCropSelectionView.croppedSelectionImage() else { return }

        let imageBgView = UIView()
        imageBgView.frame = view.frame
        imageBgView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        view.addSubview(imageBgView)

        let imageView = UIImageView(image: image)
        view.addSubview(imageView)
        imageView.frame = view.frame.insetBy(dx: 50, dy: 50)
        imageView.contentMode = .scaleAspectFit

        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            imageView.removeFromSuperview()
            imageBgView.removeFromSuperview()
        }
    }
}

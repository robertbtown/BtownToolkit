//
//  LoadingViewViewController.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2017-08-11.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import BtownToolkit

class LoadingViewViewController: UIViewController, BTWLocalize {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Localized title string
        title = btwClassString("Title")
    }

    @IBAction func showLoadingViewNormal() {
        let loadingViewController = LoadingViewController(loadingText: btwGeneralString("LoadingText"), completionText: btwGeneralString("LoadingCompletion"), completionErrorText: btwGeneralString("LoadingCompletionError"))
        loadingViewController.startLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            loadingViewController.stopLoading()
        }
    }

    @IBAction func showLoadingViewWithCompletion() {
        let loadingViewController = LoadingViewController(loadingText: "Loading...", completionText: "Completed!", completionErrorText: "Some error occured")
        loadingViewController.startLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            loadingViewController.stopLoadingWithCompletion()
        }
    }

    @IBAction func showLoadingViewWithCompletionAndError() {
        let loadingViewController = LoadingViewController(loadingText: "Loading...", completionText: "Completed!", completionErrorText: "Some error occured")
        loadingViewController.startLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            loadingViewController.stopLoadingWithCompletion(withError: true, autoDismissDelay: 3.0)
        }
    }
}

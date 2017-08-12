//
//  AlertViewViewController.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2016-09-25.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import BtownToolkit

class AlertViewViewController: UIViewController, BTWLocalize {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Localized title string
        title = btwClassString("Title")

        AlertView.prefersStatusBarHidden = false
    }

    @IBAction func showNormalAlertView() {
        let alertView = AlertView(title: "My normal AlertView", message: "Some information text about this alertview.")
        alertView.addAction(title: "Main Action", actionType: .normal) {
            print("User tapped main action")
        }
        alertView.addAction(title: "Cancel", actionType: .cancel) {
            print("User tapped cancel")
        }
        alertView.addAction(title: "Delete", actionType: .destructive) {
            print("User tapped delete")
        }
        alertView.wasDismissedClosure = {
            print("AlertView was dismissed.")
        }
        alertView.show()
    }

    @IBAction func showTextfiledAlertView() {
        let alertView = AlertView(title: "My textfield AlertView", message: "Some information text about this alertview.")
        alertView.addAction(title: "Main Action", actionType: .normal) {
            print("User tapped main action")
        }
        alertView.addAction(title: "Cancel", actionType: .cancel) {
            print("User tapped cancel")
        }
        alertView.addTextField(identifier: "TextField1") { textField in
            textField.font = .boldSystemFont(ofSize: 17)
        }
        alertView.wasDismissedClosure = {
            print("AlertView was dismissed.")
        }
        alertView.show()
    }
}

//
//  ActionSheetViewController.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2017-08-09.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import BtownToolkit

class ActionSheetViewController: UIViewController {

    @IBOutlet var actionSheetBarButtonItem: UIBarButtonItem!
    @IBOutlet var actionSheetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ActionSheet"
        ActionSheet.prefersStatusBarHidden = false
    }

    @IBAction func showActionSheetFromButton() {
        let actionSheet = createActionSheet()
        actionSheet.presentFromView = self.actionSheetButton
        actionSheet.show()
    }

    @IBAction func showActionSheetFromBarButtonItem() {
        let actionSheet = createActionSheet()
        actionSheet.presentFromBarButtonItem = self.actionSheetBarButtonItem
        actionSheet.show()
    }
    
    private func createActionSheet() -> ActionSheet {
        let actionSheet = ActionSheet(title: "Some title", message: "Some message")
        actionSheet.addAction(title: "Main Action", actionType: .normal) {
            print("User tapped main action")
        }
        actionSheet.addAction(title: "Cancel", actionType: .cancel) {
            print("User tapped cancel")
        }
        actionSheet.addAction(title: "Delete", actionType: .destructive) {
            print("User tapped delete")
        }
        actionSheet.wasDismissedClosure = {
            print("ActionSheet was dismissed.")
        }
        return actionSheet
    }
}

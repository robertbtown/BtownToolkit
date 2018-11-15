//
//  ActionSheetAction.swift
//  Pods
//
//  Created by Robert Magnusson on 2017-08-09.
//
//

import Foundation

class ActionSheetAction {
    let title: String
    let actionCallback: ActionSheetActionCallback?

    init(title: String, actionCallback: ActionSheetActionCallback?) {
        self.title = title
        self.actionCallback = actionCallback
    }
}

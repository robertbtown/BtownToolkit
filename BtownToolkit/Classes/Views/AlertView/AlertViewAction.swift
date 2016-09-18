//
//  AlertViewAction.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 16/09/16.
//  Copyright © 2016 Robert Magnusson. All rights reserved.
//

import Foundation

class AlertViewAction {
    let title: String
    let actionCallback: AlertViewActionCallback?
    
    init(title: String, actionCallback: AlertViewActionCallback?) {
        self.title = title
        self.actionCallback = actionCallback
    }
}

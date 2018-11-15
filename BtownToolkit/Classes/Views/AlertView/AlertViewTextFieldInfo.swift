//
//  AlertViewTextFieldInfo.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 16/09/16.
//  Copyright © 2016 Robert Magnusson. All rights reserved.
//

import Foundation

class AlertViewTextFieldInfo {
    let identifier: String
    let configurationsClosure: TextFieldConfigurationClosure?

    init(identifier: String, configurationsClosure: TextFieldConfigurationClosure?) {
        self.identifier = identifier
        self.configurationsClosure = configurationsClosure
    }
}

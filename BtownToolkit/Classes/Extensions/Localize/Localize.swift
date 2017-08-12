//
//  Localize.swift
//  Pods
//
//  Created by Robert Magnusson on 2017-08-12.
//
//

import Foundation

public func btwGeneralString(_ key: String) -> String {
    return Bundle.main.localizedString(forKey: key, value: "", table: nil)
}

public protocol BTWLocalize {
    static func btwClassString(_ key: String) -> String
    func btwClassString(_ key: String) -> String
}

public extension BTWLocalize {
    static func btwClassString(_ key: String) -> String {
        let stringKey = String(describing: self) + "." + key
        return Bundle.main.localizedString(forKey: stringKey, value: "", table: nil)
    }
    
    func btwClassString(_ key: String) -> String {
        let stringKey = String(describing: type(of: self)) + "." + key
        return Bundle.main.localizedString(forKey: stringKey, value: "", table: nil)
    }
}

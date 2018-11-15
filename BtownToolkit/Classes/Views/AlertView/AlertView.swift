//
//  AlertView.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 28/08/16.
//  Copyright © 2016 Robert Magnusson. All rights reserved.
//

// swiftlint:disable line_length

import UIKit
import ObjectiveC

public typealias AlertViewActionCallback = () -> Void
public typealias TextFieldConfigurationClosure = (UITextField) -> Void

public enum AlertViewActionType {
    case destructive
    case cancel
    case normal
}

public class AlertView {

    let title: String
    let message: String?

    private var destructiveAction: AlertViewAction?
    private var cancelAction: AlertViewAction?

    private var otherActions = [AlertViewAction]()
    private var textFieldInfos = [AlertViewTextFieldInfo]()
    private var textFieldInfoMapper = [String: UITextField]()

    /**
        If set then this closure is called when the AlertView disappears.
     */
    public var wasDismissedClosure: (() -> Void)?

    public init(title: String?, message: String?) {
        self.title = title ?? ""
        self.message = message
    }

    deinit {
        if let wasDismissedClosure = wasDismissedClosure {
            DispatchQueue.main.async {
                wasDismissedClosure()
            }
        }
    }

    /**
        Add an action button to AlertView.
     
        - parameter title: The title of the action button
        - parameter actionType: The type of action.
        - parameter actionCallback: Optional callback to be called when user taps on action button
     */
    public func addAction(title: String, actionType: AlertViewActionType, actionCallback: AlertViewActionCallback?) {
        let action = AlertViewAction(title: title, actionCallback: actionCallback)
        switch actionType {
        case .destructive:
            destructiveAction = action
        case .cancel:
            cancelAction = action
        case .normal:
            otherActions.append(action)
        }
    }

    /**
        Add a TextField to AlertView. TextField can later be retrieved using
        the identifier string. Add all wanted configuration of TextField in the configurationsBlock.
     
        - parameter identifier: An ID-string that can be used to later retrieve the TextField
        - parameter configurationsClosure: An id-string that can be used to later retrieve the TextField
     */
    public func addTextField(identifier: String, configurationsClosure: TextFieldConfigurationClosure?) {
        let textFieldInfo = AlertViewTextFieldInfo(identifier: identifier, configurationsClosure: configurationsClosure)
        textFieldInfos.append(textFieldInfo)
    }

    /**
        Retrieves a TextField with a given identifier.
        If no textField with the givien identifier was added, then returns nil.
     
        - parameter identifier: ID-string of the TextField that should be returned
     */
    public func textFieldForIdentifier(_ identifier: String) -> UITextField? {
        return textFieldInfoMapper[identifier]
    }

    /**
        Triggers the AlertView to show
     */
    public func show() {

        let sharedPresenter = AlertViewPresenter.sharedPresenter
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let destructiveAction = self.destructiveAction {
            let destructiveAlertAction = UIAlertAction(title: destructiveAction.title, style: .destructive, handler: { _ in
                sharedPresenter.didDismissAlertViewController()
                destructiveAction.actionCallback?()
            })
            alertController.addAction(destructiveAlertAction)
        }

        if let cancelAction = self.cancelAction {
            let cancelAlertAction = UIAlertAction(title: cancelAction.title, style: .cancel, handler: { _ in
                sharedPresenter.didDismissAlertViewController()
                cancelAction.actionCallback?()
            })
            alertController.addAction(cancelAlertAction)
        }

        for otherAction in otherActions {
            let otherAlertAction = UIAlertAction(title: otherAction.title, style: .default, handler: { _ in
                sharedPresenter.didDismissAlertViewController()
                otherAction.actionCallback?()
            })
            alertController.addAction(otherAlertAction)
        }

        textFieldInfoMapper.removeAll()
        for textFieldInfo in textFieldInfos {
            alertController.addTextField(configurationHandler: { [weak self] textField in
                textFieldInfo.configurationsClosure?(textField)
                self?.textFieldInfoMapper[textFieldInfo.identifier] = textField
            })
        }

        /**
            Associate self with AlertController so that self doesn't get
            deallocated until AlertController gets deallocated.
         */
        objc_setAssociatedObject(alertController, "AlertViewKey", self, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        // Present the AlertController
        sharedPresenter.present(alertController, animated: true) { }
    }
}

//
//  ActionSheet.swift
//  Pods
//
//  Created by Robert Magnusson on 2017-08-09.
//
//

import UIKit
import ObjectiveC

public typealias ActionSheetActionCallback = () -> ()

public enum ActionSheetActionType {
    case destructive
    case cancel
    case normal
}

public class ActionSheet {

    let title: String
    let message: String?

    private var destructiveAction: ActionSheetAction?
    private var cancelAction: ActionSheetAction?

    private var otherActions = [ActionSheetAction]()

    private var ipadInternalPresentFromView: UIView?

    /**
     If set then this closure is called when the AlertView disappears.
     */
    public var wasDismissedClosure: (() -> ())?


    /**
     If ActionSheet is presented on an iPad you need to set either presentFromView or 
     presentFromBarButtonItem. The ActionSheet will then appear from that frame with 
     an arrow pointing to it.
     */
    public var presentFromView: UIView?

    /**
     If ActionSheet is presented on an iPad you need to set either presentFromView or
     presentFromBarButtonItem. The ActionSheet will then appear from that frame with
     an arrow pointing to it.
     */
    public var presentFromBarButtonItem: UIBarButtonItem?

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
        if let ipadInternalPresentFromView = self.ipadInternalPresentFromView {
            ipadInternalPresentFromView.removeFromSuperview()
        }
    }

    /**
     Add an action button to ActionSheet.
     
     - parameter title: The title of the action button
     - parameter actionType: The type of action.
     - parameter actionCallback: Optional callback to be called when user taps on action button
     */
    public func addAction(title: String, actionType: ActionSheetActionType, actionCallback: ActionSheetActionCallback?) {
        let action = ActionSheetAction(title: title, actionCallback: actionCallback)
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
     Triggers the ActionSheet to show
     */
    public func show() {

        let sharedPresenter = ViewPresenter.sharedPresenter
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        if let destructiveAction = self.destructiveAction {
            let destructiveAlertAction = UIAlertAction(title: destructiveAction.title, style: .destructive, handler: { _ in
                sharedPresenter.didDismissViewController()
                destructiveAction.actionCallback?()
            })
            alertController.addAction(destructiveAlertAction)
        }

        if let cancelAction = self.cancelAction {
            let cancelAlertAction = UIAlertAction(title: cancelAction.title, style: .cancel, handler: { _ in
                sharedPresenter.didDismissViewController()
                cancelAction.actionCallback?()
            })
            alertController.addAction(cancelAlertAction)
        }

        for otherAction in otherActions {
            let otherAlertAction = UIAlertAction(title: otherAction.title, style: .default, handler: { _ in
                sharedPresenter.didDismissViewController()
                otherAction.actionCallback?()
            })
            alertController.addAction(otherAlertAction)
        }

        var sourceView: UIView?
        if let presentFromBarButtonItem = self.presentFromBarButtonItem {
            sourceView = presentFromBarButtonItem.value(forKey: "view") as? UIView
        } else if let presentFromView = self.presentFromView {
            sourceView = presentFromView
        }

        if let sourceView = sourceView {
            let aFrame = sourceView.convert(sourceView.bounds, to: sharedPresenter.viewPresenterVC.view)
            if self.ipadInternalPresentFromView == nil {
                let ipadInternalPresentFromView = UIView()
                sharedPresenter.viewPresenterVC.view.addSubview(ipadInternalPresentFromView)
                self.ipadInternalPresentFromView = ipadInternalPresentFromView
            }
            if let ipadInternalPresentFromView = ipadInternalPresentFromView {
                ipadInternalPresentFromView.frame = aFrame
                ipadInternalPresentFromView.isHidden = true
                alertController.popoverPresentationController?.sourceView = ipadInternalPresentFromView
                alertController.popoverPresentationController?.sourceRect = ipadInternalPresentFromView.bounds
            }
        }

        /**
         Associate self with AlertController so that self doesn't get
         deallocated until AlertController gets deallocated.
         */
        objc_setAssociatedObject(alertController, "ActionSheetViewKey", self, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        // Present the AlertController
        sharedPresenter.present(alertController, animated: true) { }
    }
}

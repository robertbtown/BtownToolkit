//
//  AlertViewPresenter.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 16/09/16.
//  Copyright © 2016 Robert Magnusson. All rights reserved.
//

import UIKit

fileprivate typealias PresentObjectCompletionClosure = () -> ()

fileprivate class AlertViewPresenterViewController : UIViewController {
    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}

fileprivate class AlertViewPresentObject {
    let alertViewController: UIViewController
    let animated: Bool
    let completionClosure: PresentObjectCompletionClosure
    var previousPresentObject: AlertViewPresentObject?
    
    init(alertViewController: UIViewController, animated: Bool, completionClosure: @escaping PresentObjectCompletionClosure) {
        self.alertViewController = alertViewController
        self.animated = animated
        self.completionClosure = completionClosure
    }
}

class AlertViewPresenter {
    
    typealias PresentVCCompletionClosure = () -> ()
    
    private let alertPresenterWindow: UIWindow
    private let alertViewPresenterVC: UIViewController
    private var presentObject: AlertViewPresentObject?
    
    static let sharedPresenter = AlertViewPresenter()
    
    /**
        Returns an AlertViewPresenter.
        Is it used to present UIAlertController on a seperate UIWindow.
        This makes UIAlertControllers behave like the old UIAlertViews
        and always appear on top of the currently diplayed content.
     */
    private init() {
        // Setup alertWindow and alertPresenterViewController to present the AlertViewControllers on.
        let alertPresenterWindow = UIWindow(frame: UIScreen.main.bounds)
        alertPresenterWindow.windowLevel = UIWindow.Level.alert
        alertPresenterWindow.backgroundColor = UIColor.clear
        
        let alertViewPresenterVC = AlertViewPresenterViewController()
        alertPresenterWindow.rootViewController = alertViewPresenterVC
        
        alertPresenterWindow.makeKeyAndVisible()
        
        self.alertPresenterWindow = alertPresenterWindow;
        self.alertViewPresenterVC = alertViewPresenterVC;
    }
    
    private func presentAlertViewPresentObject(_ presentObject: AlertViewPresentObject) {
        alertPresenterWindow.isHidden = false
        alertViewPresenterVC.present(presentObject.alertViewController, animated: presentObject.animated, completion: presentObject.completionClosure)
    }
    
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completionClosure: @escaping PresentVCCompletionClosure) {
        let nextPresentObject = AlertViewPresentObject(alertViewController: viewControllerToPresent, animated: animated, completionClosure: completionClosure)
        
        /**
            Check if an alertViewController is already presented.
            If so then dismiss the one that is presented and store it
            as a previous. Then display the new alertViewController.
         */
        if let presentObject = self.presentObject {
            nextPresentObject.previousPresentObject = presentObject;
            self.presentObject = nextPresentObject;
            
            let previousAlertViewController = nextPresentObject.previousPresentObject?.alertViewController
            previousAlertViewController?.dismiss(animated: animated, completion: { [weak self] in
                self?.presentAlertViewPresentObject(nextPresentObject)
            })
        }
        else {
            self.presentObject = nextPresentObject;
            self.presentAlertViewPresentObject(nextPresentObject)
        }
    }
    
    func didDismissAlertViewController() {
        if let previousPresentObject = self.presentObject?.previousPresentObject {
            self.presentObject = previousPresentObject
            self.presentAlertViewPresentObject(previousPresentObject)
        }
        else {
            self.presentObject = nil;
            self.alertPresenterWindow.isHidden = true
        }
    }
}

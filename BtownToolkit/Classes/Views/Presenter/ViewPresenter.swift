//
//  ViewPresenter.swift
//  Pods
//
//  Created by Robert Magnusson on 2017-08-09.
//
//

// swiftlint:disable line_length

import UIKit

private typealias PresentObjectCompletionClosure = () -> Void

private class ViewPresenterViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}

private class ViewPresentObject {
    let viewController: UIViewController
    let animated: Bool
    let completionClosure: PresentObjectCompletionClosure?
    var previousPresentObject: ViewPresentObject?

    init(viewController: UIViewController, animated: Bool, completionClosure: PresentObjectCompletionClosure?) {
        self.viewController = viewController
        self.animated = animated
        self.completionClosure = completionClosure
    }
}

public class ViewPresenter {

    typealias PresentVCCompletionClosure = () -> Void

    private let presenterWindow: UIWindow
    let viewPresenterVC: UIViewController
    private var presentObject: ViewPresentObject?

    static let sharedPresenter = ViewPresenter()

    static var newPresentationDismissesPrevFirst = false

    /**
     Returns an ViewPresenter.
     Is it used to present UIViewControllers on a seperate UIWindow.
     This makes UIViewControllers behave like the old UIAlertViews
     and always appear on top of the currently diplayed content.
     */
    private init() {
        // Setup presenterWindow and presenterViewController to present the ViewControllers on.
        let presenterWindow = UIWindow(frame: UIScreen.main.bounds)
        presenterWindow.windowLevel = UIWindow.Level.alert
        presenterWindow.backgroundColor = UIColor.clear

        let viewPresenterVC = ViewPresenterViewController()
        presenterWindow.rootViewController = viewPresenterVC

        presenterWindow.makeKeyAndVisible()

        self.presenterWindow = presenterWindow
        self.viewPresenterVC = viewPresenterVC
    }

    private func presentViewPresentObject(_ presentObject: ViewPresentObject) {
        presenterWindow.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let strongSelf = self else { return }
            let presenterVC: UIViewController
            if let prevVC = presentObject.previousPresentObject?.viewController, !ViewPresenter.newPresentationDismissesPrevFirst {
                presenterVC = prevVC
            } else {
                presenterVC = strongSelf.viewPresenterVC
            }
            presenterVC.present(presentObject.viewController, animated: presentObject.animated, completion: presentObject.completionClosure)
        }
    }

    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completionClosure: PresentVCCompletionClosure? = nil) {
        let nextPresentObject = ViewPresentObject(viewController: viewControllerToPresent, animated: animated, completionClosure: completionClosure)

        /**
         Check if a ViewController is already presented.
         If so then dismiss the one that is presented and store it
         as a previous. Then display the new ViewController.
         */
        if let presentObject = self.presentObject {
            nextPresentObject.previousPresentObject = presentObject
            self.presentObject = nextPresentObject

            if ViewPresenter.newPresentationDismissesPrevFirst {
                let previousViewController = nextPresentObject.previousPresentObject?.viewController
                previousViewController?.dismiss(animated: animated, completion: { [weak self] in
                    self?.presentViewPresentObject(nextPresentObject)
                })
            } else {
                self.presentViewPresentObject(nextPresentObject)
            }
        } else {
            self.presentObject = nextPresentObject
            self.presentViewPresentObject(nextPresentObject)
        }
    }

    func didDismissViewController() {
        if let previousPresentObject = self.presentObject?.previousPresentObject {
            self.presentObject = previousPresentObject
            if ViewPresenter.newPresentationDismissesPrevFirst {
                self.presentViewPresentObject(previousPresentObject)
            }
        } else {
            self.presentObject = nil
            self.presenterWindow.isHidden = true
        }
    }
}

//
//  LoadingViewController.swift
//  Pods
//
//  Created by Robert Magnusson on 2017-08-11.
//
//

// swiftlint:disable line_length

import UIKit

/// This class manages a LoadingView.
/// It is easily created like this:
///     let loadingViewController = LoadingViewController(loadingText: "Loading...", completionText: "Completed!", completionErrorText: "Some error occured")
///     loadingViewController.startLoading()
///
/// The loadingview will be presented in its own Window on top of all your other UI.
///
/// There is a default LoadingView that will be used, but you can easily create your own LoadingViews by conforming to LoadingViewProtocol
/// That way you can control yourself how the LoadingView will look.
/// Then you just need to pass your CustomLoadingView in when creating the LoadingViewController.
/// Like this:
///     let loadingView = LoadingViewController(loadingViewType: MyCustomLoadingView.self, loadingText: "Loading", completionText: "Completed", completionErrorText: "Error")
///     loadingView.startLoading()
///
/// For inspiration on how to create a custom LoadingView, the checkout the code in DefaultLoadingView.swift
public class LoadingViewController {

    fileprivate struct Constants {
        static let defaultAutoDismissDelay = 1.5
        static let minPresentationTime = 0.5
    }

    fileprivate let loadingText: String?
    fileprivate let completionText: String?
    fileprivate let completionErrorText: String?

    /// Use this to update how much of the loading that is currently completed.
    /// It will default to zero on init.
    public var completionPercentage: Float? {
        didSet {
            loadingViewVC?.completionPercentage = completionPercentage
        }
    }

    /// If the LoadingView is stopped with a completion (meaning it shows a completion state)
    /// then this is the time it will stay visible after completion. After this time, the LoadingView
    /// will be dismissed.
    public static var completionAutoDismissDelay: TimeInterval = Constants.defaultAutoDismissDelay

    fileprivate let loadingViewType: LoadingViewProtocol.Type
    fileprivate weak var loadingViewVC: LoadingViewViewController?

    fileprivate(set) var isLoading: Bool
    fileprivate var startLoadingTime: CFTimeInterval?

    public init(loadingViewType: LoadingViewProtocol.Type = DefaultLoadingView.self, loadingText: String? = nil, completionText: String? = nil, completionErrorText: String? = nil) {
        self.loadingViewType = loadingViewType
        self.loadingText = loadingText
        self.completionText = completionText
        self.completionErrorText = completionErrorText
        self.isLoading = false
        self.completionPercentage = 0
    }
}

// MARK: Public methods

public extension LoadingViewController {

    /// Presents the LoadingView and start loading.
    public func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.presentViewAndStartLoading()
        }
    }

    /// Stops the LoadingView and directly dismisses it.
    public func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.stopLoadingAndDismissView(withCompletionState: false, autoDismissDelay: 0, withError: false)
        }
    }

    /// Stops the LoadingView and shows a completion state.
    /// The LoadingView will be dismissed after autoDismissDelay. By default the autoDismissDelay is set to be LoadingViewController.completionAutoDismissDelay
    ///
    /// - Parameters:
    ///   - withError: Indicates if an error occured. If this is true, then an Error state is shown with the completionErrorText
    ///   - autoDismissDelay: the time LoadingView should stay visible after it completes. By default this is set to be LoadingViewController.completionAutoDismissDelay
    public func stopLoadingWithCompletion(withError: Bool = false, autoDismissDelay: TimeInterval = LoadingViewController.completionAutoDismissDelay) {
        DispatchQueue.main.async { [weak self] in
            self?.stopLoadingAndDismissView(withCompletionState: true, autoDismissDelay: autoDismissDelay, withError: withError)
        }
    }
}

// MARK: Private helper methods

fileprivate extension LoadingViewController {
    func presentViewAndStartLoading() {
        guard !isLoading else { return }
        isLoading = true

        let sharedPresenter = ViewPresenter.sharedPresenter

        let loadingViewVC = LoadingViewViewController(loadingViewType: loadingViewType, loadingText: loadingText, completionSuccessText: completionText, completionErrorText: completionErrorText)
        sharedPresenter.present(loadingViewVC, animated: false) { [weak self] in
            self?.startLoadingTime = CACurrentMediaTime()
            loadingViewVC.startLoading()
        }
        self.loadingViewVC = loadingViewVC

        /**
         Associate self with loadingViewViewController so that self doesn't get
         deallocated until loadingViewViewController gets deallocated.
         */
        objc_setAssociatedObject(loadingViewVC, "LoadingViewKey", self, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func stopLoadingAndDismissView(withCompletionState: Bool, autoDismissDelay: TimeInterval, withError: Bool) {
        guard isLoading else { return }

        DispatchQueue.main.asyncAfter(deadline: stopLoadingDispatchTime(), execute: { [weak self] in
            guard let `self` = self else { return }
            if let loadingViewVC = self.loadingViewVC {
                loadingViewVC.stopLoading(withCompletionState: withCompletionState, autoDismissDelay: autoDismissDelay, withError: withError) { [weak self] in
                    guard let `self` = self else { return }
                    self.loadingViewVC?.dismiss(animated: false, completion: nil)
                    ViewPresenter.sharedPresenter.didDismissViewController()
                    self.loadingViewVC = nil
                    self.isLoading = false
                }
            } else {
                self.isLoading = false
            }
        })
    }

    func stopLoadingDispatchTime() -> DispatchTime {
        let startLoadingTime = self.startLoadingTime ?? CACurrentMediaTime()
        let stopLoadingTime = CACurrentMediaTime()
        let loadingTime = (stopLoadingTime - startLoadingTime)

        // If loading time is less than min loading time, then append a diff as delay
        let loadingDelta = Constants.minPresentationTime - loadingTime
        let delay = loadingDelta > 0 ? loadingDelta : 0

        return .now() + delay
    }
}

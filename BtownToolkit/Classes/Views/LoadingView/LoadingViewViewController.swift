//
//  LoadingViewViewController.swift
//  Pods
//
//  Created by Robert Magnusson on 2017-08-11.
//
//

import UIKit

/// This protocol defines a LoadingView.
/// You can create your own LoadingViews by conforming to this LoadingViewProtocol
/// That way you can control yourself how the LoadingView will look.
/// Then you just need to pass your CustomLoadingView in when creating the LoadingViewController.
/// Like this:
///     let loadingView = LoadingViewController(loadingViewType: MyCustomLoadingView.self, loadingText: "Loading", completionText: "Completed", completionErrorText: "Error")
///     loadingView.startLoading()
public protocol LoadingViewProtocol {
    typealias CompletionClosure = () -> ()

    /// Use this to update how much of the loading that is currently completed.
    /// It will default to zero on init.
    var completionPercentage: Float? { get set }

    /// Creates an instance of the LoadingView.
    /// All parameters in are optional except for the view.
    /// This view is where you can add your custom views to display loading.
    /// The view covers the entire window.
    ///
    /// - Parameters:
    ///   - view: The container view that you show your loading views in.
    ///   - loadingText: Optional loading text.
    ///   - completionSuccessText: A completion text to show when loading is done without errors
    ///   - completionErrorText: A error text to show when loading is done with errors
    init(withView view: UIView, loadingText: String?, completionSuccessText: String?, completionErrorText: String?)

    /// Every time the container view get a new layout this function is called.
    /// Update the layout of your views in this function.
    func viewChangedLayout()

    /// When this function is called you should set your loading view in a loading state.
    /// When this function gets called the container view will be presented and show your views.
    func startLoading()

    /// When this function is called you should stop your loading view from loading.
    /// If withCompletionState is true then the loading view will not be dismissed directly.
    /// Instead you should change it to display a completion state.
    /// If withCompletionState is false then the loading view will be dismissed.
    ///
    /// - Parameters:
    ///   - withCompletionState: Indicates if a completion state should be shown after loading has stopped
    ///   - autoDismissDelay: The delay until the loading view will be dismissed.
    ///   - withError: Indicates if the loading was stopped with an error, meaning you should show an error state
    ///   - completionClosure: This block must be called. Call it after you are done with any potential code to hide your view.
    func stopLoading(withCompletionState: Bool, autoDismissDelay: TimeInterval, withError: Bool, completionClosure: @escaping CompletionClosure)
}

class LoadingViewViewController: UIViewController {

    private let loadingViewType: LoadingViewProtocol.Type
    fileprivate let loadingText: String?
    fileprivate let completionSuccessText: String?
    fileprivate let completionErrorText: String?

    fileprivate var loadingView: LoadingViewProtocol?

    var completionPercentage: Float? {
        didSet {
            loadingView?.completionPercentage = completionPercentage
        }
    }

    init(loadingViewType: LoadingViewProtocol.Type, loadingText: String? = nil, completionSuccessText: String? = nil, completionErrorText: String? = nil) {
        self.loadingViewType = loadingViewType
        self.loadingText = loadingText
        self.completionSuccessText = completionSuccessText
        self.completionErrorText = completionErrorText

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .clear

        view.setNeedsUpdateConstraints()
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView = loadingViewType.init(withView: view, loadingText: loadingText, completionSuccessText: completionSuccessText, completionErrorText: completionErrorText)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingView?.viewChangedLayout()
    }

    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}

// MARK: Public functions

extension LoadingViewViewController {
    func startLoading() {
        loadingView?.startLoading()
    }

    func stopLoading(withCompletionState: Bool, autoDismissDelay: TimeInterval, withError: Bool, completionClosure: @escaping LoadingViewProtocol.CompletionClosure) {
        if let loadingView = loadingView {
            loadingView.stopLoading(withCompletionState: withCompletionState, autoDismissDelay: autoDismissDelay, withError: withError, completionClosure: {
                completionClosure()
            })
        } else {
            completionClosure()
        }
    }
}

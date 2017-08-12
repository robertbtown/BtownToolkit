//
//  DefaultLoadingView.swift
//  Pods
//
//  Created by Robert Magnusson on 2017-08-11.
//
//

import UIKit
import PureLayout
import AngleGradientLayer


/// This is a sample class of a LoadingView.
/// You can create your own LoadingViews by conforming to LoadingViewProtocol
/// That way you can control yourself how the LoadingView will look.
/// Then you just need to pass your CustomLoadingView in when creating the LoadingViewController.
/// Like this:
///     let loadingView = LoadingViewController(loadingViewType: MyCustomLoadingView.self, loadingText: "Loading", completionText: "Completed", completionErrorText: "Error")
///     loadingView.startLoading()
public class DefaultLoadingView: LoadingViewProtocol {

    fileprivate enum LoadingState {
        case loading
        case completed(withError: Bool)
    }

    fileprivate let view: UIView
    fileprivate let loadingText: String?
    fileprivate let completionSuccessText: String?
    fileprivate let completionErrorText: String?

    public var completionPercentage: Float?

    static var loadingColor = UIColor(red: 54.0 / 255.0, green: 109.0 / 255.0, blue: 203.0 / 255.0, alpha: 1)
    static var completeColor = UIColor(red: 54.0 / 255.0, green: 109.0 / 255.0, blue: 203.0 / 255.0, alpha: 1)
    static var errorColor = UIColor(red: 203.0 / 255.0, green: 54.0 / 255.0, blue: 54.0 / 255.0, alpha: 1)

    required public init(withView view: UIView, loadingText: String? = nil, completionSuccessText: String? = nil, completionErrorText: String? = nil) {
        self.view = view
        self.loadingText = loadingText
        self.completionSuccessText = completionSuccessText
        self.completionErrorText = completionErrorText

        setupViews()

        updateViewForLoadingState(.loading)
    }

    public func viewChangedLayout() {
        layoutSubviews()
    }

    public func startLoading() {
        updateViewForLoadingState(.loading, animated: true)
        presentLoadingView()
    }

    public func stopLoading(withCompletionState: Bool, autoDismissDelay: TimeInterval, withError: Bool, completionClosure: @escaping CompletionClosure) {
        // If we should show a completionState. Then update loading state.
        if withCompletionState {
            updateViewForLoadingState(.completed(withError: withError), animated: true)
        }

        self.dismissLoadingView(withDelay: autoDismissDelay, completion: {
            completionClosure()
        })
    }

    // MARK: Private variables

    fileprivate static let circleSize: CGFloat = 70
    fileprivate static let circleLineWidth: CGFloat = 4
    fileprivate static let checkmarkLineWidth: CGFloat = 4
    fileprivate static let rotationTime: Double = 0.7
    fileprivate static let checkmarkCrossSize = (circleSize-2 * circleLineWidth) * 0.6
    fileprivate static let loadingContainerSize = circleSize * 3

    fileprivate var loadingColor: UIColor {
        return DefaultLoadingView.loadingColor
    }
    fileprivate var completeColor: UIColor {
        return DefaultLoadingView.completeColor
    }
    fileprivate var errorColor: UIColor {
        return DefaultLoadingView.errorColor
    }
    fileprivate let backgroundColor = UIColor(white: 0, alpha: 0.7)

    fileprivate let backgroundView = UIView()
    fileprivate let loadingContainerView = UIView()
    fileprivate let spinnerAndTextContainerView = UIView()

    fileprivate let circleContainerView = UIView()
    fileprivate let spinningCircleView = UIView()
    fileprivate let completionCircleView = UIView()

    fileprivate let checkmarkView = UIView()
    fileprivate let crossView = UIView()

    fileprivate let loadingLabel = UILabel()

    fileprivate let spinningCircleViewGradientLayer = AngleGradientLayer()
    fileprivate let spinningCircleViewShapeLayer = CAShapeLayer()
    fileprivate let completionCircleViewGradientLayer = AngleGradientLayer()
    fileprivate let completionErrorCircleViewGradientLayer = AngleGradientLayer()
    fileprivate let completionCircleViewShapeLayer = CAShapeLayer()
    fileprivate let completionErrorCircleViewShapeLayer = CAShapeLayer()
    fileprivate let checkmarkViewShapeLayer = CAShapeLayer()
    fileprivate let crossViewShapeLayer = CAShapeLayer()
}

private extension DefaultLoadingView {

    func setupViews() {
        setupBackgroundView()
        setupLoadingContainerViews()
        setupSpinningCircleView()
        setupLoadingLabel()
        setupCheckmarkView()
        setupCrossView()

        setupConstraints()
    }

    func setupBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = backgroundColor
        view.addSubview(backgroundView)
    }

    func setupLoadingContainerViews() {
        loadingContainerView.translatesAutoresizingMaskIntoConstraints = false
        loadingContainerView.backgroundColor = .white
        loadingContainerView.layer.cornerRadius = DefaultLoadingView.loadingContainerSize / 6.0
        view.addSubview(loadingContainerView)

        spinnerAndTextContainerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerAndTextContainerView.backgroundColor = .clear
        loadingContainerView.addSubview(spinnerAndTextContainerView)
    }

    func setupSpinningCircleView() {
        circleContainerView.translatesAutoresizingMaskIntoConstraints = false
        circleContainerView.backgroundColor = .clear
        spinnerAndTextContainerView.addSubview(circleContainerView)

        // Spinning circle
        spinningCircleView.translatesAutoresizingMaskIntoConstraints = false
        spinningCircleView.backgroundColor = .clear
        circleContainerView.addSubview(spinningCircleView)

        styleAngleGradientLayer(layer: spinningCircleViewGradientLayer)
        spinningCircleViewGradientLayer.colors = [loadingColor.cgColor, loadingColor.withAlphaComponent(0.01).cgColor]
        spinningCircleView.layer.addSublayer(spinningCircleViewGradientLayer)

        styleShapeLayer(layer: spinningCircleViewShapeLayer)
        spinningCircleViewGradientLayer.mask = spinningCircleViewShapeLayer

        // Completion circle
        completionCircleView.translatesAutoresizingMaskIntoConstraints = false
        completionCircleView.backgroundColor = .clear
        circleContainerView.addSubview(completionCircleView)

        styleAngleGradientLayer(layer: completionCircleViewGradientLayer)
        completionCircleViewGradientLayer.colors = [completeColor.cgColor]
        completionCircleView.layer.addSublayer(completionCircleViewGradientLayer)

        styleShapeLayer(layer: completionCircleViewShapeLayer)
        completionCircleViewGradientLayer.mask = completionCircleViewShapeLayer

        styleAngleGradientLayer(layer: completionErrorCircleViewGradientLayer)
        completionErrorCircleViewGradientLayer.colors = [errorColor.cgColor]
        completionCircleView.layer.addSublayer(completionErrorCircleViewGradientLayer)

        styleShapeLayer(layer: completionErrorCircleViewShapeLayer)
        completionErrorCircleViewGradientLayer.mask = completionErrorCircleViewShapeLayer
    }

    func setupLoadingLabel() {
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.backgroundColor = .clear
        loadingLabel.numberOfLines = 0
        loadingLabel.lineBreakMode = .byWordWrapping
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont.systemFont(ofSize: 15)
        loadingLabel.textColor = loadingColor

        spinnerAndTextContainerView.addSubview(loadingLabel)
    }

    func setupCheckmarkView() {
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.backgroundColor = completeColor
        circleContainerView.addSubview(checkmarkView)

        checkmarkViewShapeLayer.fillColor = UIColor.clear.cgColor
        checkmarkViewShapeLayer.strokeColor = UIColor.purple.cgColor
        checkmarkViewShapeLayer.lineCap = kCALineCapRound
        checkmarkViewShapeLayer.lineJoin = kCALineJoinRound
        checkmarkViewShapeLayer.lineWidth = DefaultLoadingView.checkmarkLineWidth
        checkmarkView.layer.mask = checkmarkViewShapeLayer
    }

    func setupCrossView() {
        crossView.translatesAutoresizingMaskIntoConstraints = false
        crossView.backgroundColor = errorColor
        circleContainerView.addSubview(crossView)

        crossViewShapeLayer.fillColor = UIColor.clear.cgColor
        crossViewShapeLayer.strokeColor = UIColor.purple.cgColor
        crossViewShapeLayer.lineCap = kCALineCapRound
        crossViewShapeLayer.lineJoin = kCALineJoinRound
        crossViewShapeLayer.lineWidth = DefaultLoadingView.checkmarkLineWidth
        crossView.layer.mask = crossViewShapeLayer
    }

    func styleShapeLayer(layer: CAShapeLayer) {
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.purple.cgColor
        layer.lineCap = kCALineCapRound
        layer.lineWidth = DefaultLoadingView.circleLineWidth
    }

    func styleAngleGradientLayer(layer: AngleGradientLayer) {
        layer.backgroundColor = UIColor.clear.cgColor
    }

    func setupConstraints() {
        let edgeMargin: CGFloat = 8

        backgroundView.autoPinEdgesToSuperviewEdges()

        loadingContainerView.autoSetDimensions(to: CGSize(width: DefaultLoadingView.loadingContainerSize, height: DefaultLoadingView.loadingContainerSize))
        loadingContainerView.autoAlignAxis(.vertical, toSameAxisOf: view)
        loadingContainerView.autoAlignAxis(.horizontal, toSameAxisOf: view)

        spinnerAndTextContainerView.autoCenterInSuperview()
        spinnerAndTextContainerView.autoMatch(.width, to: .width, of: loadingContainerView)
        spinnerAndTextContainerView.autoMatch(.height, to: .height, of: loadingContainerView, withOffset: 0, relation: .lessThanOrEqual)

        circleContainerView.autoSetDimensions(to: CGSize(width: DefaultLoadingView.circleSize, height: DefaultLoadingView.circleSize))
        circleContainerView.autoPinEdge(.top, to: .top, of: spinnerAndTextContainerView, withOffset: edgeMargin * 2)
        circleContainerView.autoAlignAxis(.vertical, toSameAxisOf: spinnerAndTextContainerView)

        spinningCircleView.autoCenterInSuperview()
        spinningCircleView.autoMatch(.height, to: .height, of: circleContainerView)
        spinningCircleView.autoMatch(.width, to: .width, of: circleContainerView)

        completionCircleView.autoCenterInSuperview()
        completionCircleView.autoMatch(.height, to: .height, of: circleContainerView)
        completionCircleView.autoMatch(.width, to: .width, of: circleContainerView)

        loadingLabel.autoAlignAxis(.vertical, toSameAxisOf: spinnerAndTextContainerView)
        loadingLabel.autoPinEdge(.top, to: .bottom, of: circleContainerView, withOffset: edgeMargin)
        loadingLabel.autoPinEdge(.bottom, to: .bottom, of: spinnerAndTextContainerView, withOffset: -edgeMargin)
        loadingLabel.autoPinEdge(.left, to: .left, of: spinnerAndTextContainerView, withOffset: edgeMargin * 2)
        loadingLabel.autoPinEdge(.right, to: .right, of: spinnerAndTextContainerView, withOffset: -edgeMargin * 2)

        checkmarkView.autoAlignAxis(.horizontal, toSameAxisOf: circleContainerView)
        checkmarkView.autoAlignAxis(.vertical, toSameAxisOf: circleContainerView)
        checkmarkView.autoSetDimensions(to: CGSize(width: DefaultLoadingView.checkmarkCrossSize, height: DefaultLoadingView.checkmarkCrossSize))

        crossView.autoAlignAxis(.horizontal, toSameAxisOf: circleContainerView)
        crossView.autoAlignAxis(.vertical, toSameAxisOf: circleContainerView)
        crossView.autoSetDimensions(to: CGSize(width: DefaultLoadingView.checkmarkCrossSize, height: DefaultLoadingView.checkmarkCrossSize))
    }

    // MARK: Layout

    func layoutSubviews() {
        updateSpinningViewLayout()
        updateCheckmarkLayout()
        updateCrossLayout()
    }

    func updateSpinningViewLayout() {
        let circleBounds = CGRect(x: 0, y: 0, width: DefaultLoadingView.circleSize, height: DefaultLoadingView.circleSize)

        spinningCircleViewGradientLayer.frame = circleBounds
        completionCircleViewGradientLayer.frame = circleBounds
        completionErrorCircleViewGradientLayer.frame = circleBounds

        let shapeLayerRect = circleBounds.insetBy(dx: DefaultLoadingView.circleLineWidth / 2.0, dy: DefaultLoadingView.circleLineWidth / 2.0)
        spinningCircleViewShapeLayer.path = UIBezierPath(ovalIn: shapeLayerRect).cgPath
        completionCircleViewShapeLayer.path = UIBezierPath(ovalIn: shapeLayerRect).cgPath
        completionErrorCircleViewShapeLayer.path = UIBezierPath(ovalIn: shapeLayerRect).cgPath
    }

    func updateCheckmarkLayout() {
        let minPos: CGFloat = DefaultLoadingView.circleLineWidth
        let size: CGFloat = DefaultLoadingView.checkmarkCrossSize-2 * DefaultLoadingView.circleLineWidth

        let firstPoint = CGPoint(x: minPos + size * 0.03, y: minPos + size * 0.6)
        let secondPoint = CGPoint(x: minPos + size * 0.27, y: minPos + size * 0.84)
        let thirdPoint = CGPoint(x: minPos + size * 0.94, y: minPos + size * 0.15)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: firstPoint)
        bezierPath.addLine(to: secondPoint)
        bezierPath.addLine(to: thirdPoint)

        checkmarkViewShapeLayer.path = bezierPath.cgPath
    }

    func updateCrossLayout() {
        let size: CGFloat = DefaultLoadingView.checkmarkCrossSize-2 * DefaultLoadingView.circleLineWidth
        let minPos: CGFloat = DefaultLoadingView.circleLineWidth + size * 0.1
        let maxPos: CGFloat = DefaultLoadingView.circleLineWidth + size * 0.9

        let firstPoint = CGPoint(x: minPos, y: minPos)
        let secondPoint = CGPoint(x: maxPos, y: maxPos)
        let thirdPoint = CGPoint(x: maxPos, y: minPos)
        let fourthPoint = CGPoint(x: minPos, y: maxPos)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: firstPoint)
        bezierPath.addLine(to: secondPoint)
        bezierPath.move(to: thirdPoint)
        bezierPath.addLine(to: fourthPoint)

        crossViewShapeLayer.path = bezierPath.cgPath
    }

    // MARK: Rotations

    func updateCircleView(shouldRotate: Bool) {
        let rotationKeyPath = "transform.rotation.z"
        if shouldRotate {
            let rotationAnimation = CABasicAnimation(keyPath: rotationKeyPath)
            rotationAnimation.toValue = 2.0 * Double.pi
            rotationAnimation.duration = DefaultLoadingView.rotationTime
            rotationAnimation.isCumulative = true
            rotationAnimation.repeatCount = Float.infinity

            spinningCircleView.layer.add(rotationAnimation, forKey: rotationKeyPath)
        } else {
            spinningCircleView.layer.removeAnimation(forKey: rotationKeyPath)
        }
    }

    // MARK: Checkmark and Cross

    func updateCheckmarkView(shouldBeVisible: Bool) {
        let strokeEndKeyPath = "strokeEnd"
        if shouldBeVisible {
            let pathAnimation = CABasicAnimation(keyPath: strokeEndKeyPath)
            pathAnimation.duration = 0.3
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1.0
            pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            pathAnimation.fillMode = kCAFillModeForwards
            pathAnimation.isRemovedOnCompletion = false
            checkmarkViewShapeLayer.add(pathAnimation, forKey: strokeEndKeyPath)
        } else {
            checkmarkViewShapeLayer.removeAnimation(forKey: strokeEndKeyPath)
            checkmarkViewShapeLayer.strokeEnd = 0
        }
    }

    func updateCrossView(shouldBeVisible: Bool) {
        let strokeEndKeyPath = "strokeEnd"
        if shouldBeVisible {
            let pathAnimation = CABasicAnimation(keyPath: strokeEndKeyPath)
            pathAnimation.duration = 0.3
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1.0
            pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            pathAnimation.fillMode = kCAFillModeForwards
            pathAnimation.isRemovedOnCompletion = false
            crossViewShapeLayer.add(pathAnimation, forKey: strokeEndKeyPath)
        } else {
            crossViewShapeLayer.removeAnimation(forKey: strokeEndKeyPath)
            crossViewShapeLayer.strokeEnd = 0
        }
    }

    // MARK: Present & Dismiss

    func presentLoadingView() {
        self.backgroundView.backgroundColor = .clear
        self.loadingContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.loadingContainerView.alpha = 0

        let loadingUpdateBlock: () -> () = { [weak self] in
            guard let `self` = self else { return }
            self.loadingContainerView.transform = .identity
            self.loadingContainerView.alpha = 1
        }
        let backgroundUpdateBlock: () -> () = { [weak self] in
            guard let `self` = self else { return }
            self.backgroundView.backgroundColor = self.backgroundColor
        }

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            loadingUpdateBlock()
        })

        UIView.animate(withDuration: 0.2) {
            backgroundUpdateBlock()
        }
    }

    func dismissLoadingView(withDelay delay: Double, completion: @escaping CompletionClosure) {
        let updateBlock: () -> () = { [weak self] in
            guard let `self` = self else { return }
            self.backgroundView.backgroundColor = .clear
            self.loadingContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.loadingContainerView.alpha = 0
        }

        UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
            updateBlock()
        }) { (finished) in
            completion()
        }
    }

    // MARK: Loading state

    func updateViewForLoadingState(_ state: LoadingState, animated: Bool = false) {
        var rotateCircleView = false
        var showCrossView = false
        var showCheckmarkView = false
        var spinningCircleViewAlpha: CGFloat = 0
        var completionCircleViewAlpha: CGFloat = 0
        var labelText: String? = nil
        let labelColor: UIColor

        switch state {
        case .loading:
            rotateCircleView = true
            spinningCircleViewAlpha = 1
            labelText = loadingText
            labelColor = loadingColor
        case .completed(withError: let error):
            completionCircleViewAlpha = 1
            if error {
                showCrossView = true
                labelText = completionErrorText
                labelColor = errorColor
            } else {
                showCheckmarkView = true
                labelText = completionSuccessText
                labelColor = completeColor
            }
        }

        completionErrorCircleViewGradientLayer.isHidden = !showCrossView
        completionCircleViewGradientLayer.isHidden = !showCheckmarkView

        updateCircleView(shouldRotate: rotateCircleView)
        updateCheckmarkView(shouldBeVisible: showCheckmarkView)
        updateCrossView(shouldBeVisible: showCrossView)

        loadingLabel.text = labelText
        loadingLabel.textColor = labelColor

        let updateCircleViewAlpha: () -> () = { [weak self] in
            guard let `self` = self else { return }
            self.completionCircleView.alpha = completionCircleViewAlpha
            self.spinningCircleView.alpha = spinningCircleViewAlpha
            self.view.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                updateCircleViewAlpha()
            })
        } else {
            updateCircleViewAlpha()
        }
    }
}

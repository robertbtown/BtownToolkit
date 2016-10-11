//
//  ScrollableImageView.swift
//  Pods
//
//  Created by Robert Magnusson on 2016-10-11.
//
//

import UIKit

public class ScrollableImageView: UIScrollView {
    
    fileprivate var lastZoomScale: CGFloat
    fileprivate var previousScrollViewFrame: CGRect
    fileprivate let imageView: UIImageView
    
    fileprivate var topImViewConstraint: NSLayoutConstraint
    fileprivate var bottomImViewConstraint: NSLayoutConstraint
    fileprivate var leftImViewConstraint: NSLayoutConstraint
    fileprivate var rightImViewConstraint: NSLayoutConstraint
    fileprivate var widthImViewConstraint: NSLayoutConstraint
    fileprivate var heightImViewConstraint: NSLayoutConstraint
    
    /**
        When 'minZoomSize' is set then image zooming is setup so that
        image can never be smaller than 'minZoomSize'.
     */
    public var minZoomSize: CGSize {
        didSet {
            let size = bounds.size
            updateConstraints(forViewSize: size)
            updateImageScrollViewZoom(forViewSize: size)
        }
    }
    
    /**
        Set scrollabel insets for image.
     */
    public var imageViewContentInset: UIEdgeInsets {
        didSet {
            updateScrollViewContentInset()
        }
    }
    
    /**
        Set the image to use in ScrollabelImageView
     */
    public var image: UIImage? {
        didSet {
            imageView.image = image
            updateScrollViewForImageChange()
        }
    }
    
    /**
        Centers image in view.
     */
    public func centerImageInView() {
        let imageViewRect = imageView.frame
        
        let widthOffset = (bounds.width-imageViewRect.width)/2
        let heightOffset = (bounds.height-imageViewRect.height)/2
        
        contentOffset = CGPoint(x: -widthOffset, y: -heightOffset)
    }
    
    /**
        Call this to make image aspect-fit in current view size
        so that image covers complete view size.
     */
    public func setImageZoomScaleToAspectFitViewSize() {
        let viewSize = bounds.size
        let imageSize = image?.size ?? CGSize(width: 1, height: 1)
        var minZoomForViewFillUp = min(viewSize.width/imageSize.width, viewSize.height/imageSize.height)
        
        if minZoomForViewFillUp > 1 {
            minZoomForViewFillUp = 1
        }
        
        zoomScale = minZoomForViewFillUp
        lastZoomScale = minZoomForViewFillUp
    }
    
    /**
        Returns cropped image that is visible in 'frame'.
        Frame should be in ScrollabelImageView-coordinate space.
     */
    public func imageForFrame(_ frame: CGRect) -> UIImage? {
        guard let image = image, let cgImage = image.cgImage else { return nil }
        
        let imageScaleFrame = CGRect(x: frame.origin.x/zoomScale,
                                     y: frame.origin.y/zoomScale,
                                     width: frame.size.width/zoomScale,
                                     height: frame.size.height/zoomScale)
        
        if let imageRef = cgImage.cropping(to: imageScaleFrame) {
            let croppedImage = UIImage(cgImage: imageRef)
            return croppedImage
        }
        else {
            return nil
        }
    }
    
    init() {
        lastZoomScale = 0
        previousScrollViewFrame = .zero
        imageView = UIImageView()
        imageViewContentInset = .zero
        minZoomSize = .zero
        
        topImViewConstraint = NSLayoutConstraint()
        bottomImViewConstraint = NSLayoutConstraint()
        leftImViewConstraint = NSLayoutConstraint()
        rightImViewConstraint = NSLayoutConstraint()
        widthImViewConstraint = NSLayoutConstraint()
        heightImViewConstraint = NSLayoutConstraint()
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        lastZoomScale = 0
        previousScrollViewFrame = .zero
        imageView = UIImageView()
        imageViewContentInset = .zero
        minZoomSize = .zero
        
        topImViewConstraint = NSLayoutConstraint()
        bottomImViewConstraint = NSLayoutConstraint()
        leftImViewConstraint = NSLayoutConstraint()
        rightImViewConstraint = NSLayoutConstraint()
        widthImViewConstraint = NSLayoutConstraint()
        heightImViewConstraint = NSLayoutConstraint()
        
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        addSubview(imageView)
        
        topImViewConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        bottomImViewConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        leftImViewConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        rightImViewConstraint = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        widthImViewConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        heightImViewConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        widthImViewConstraint.priority = UILayoutPriorityRequired-1
        heightImViewConstraint.priority = UILayoutPriorityRequired-1
        
        addConstraints([
            topImViewConstraint,
            bottomImViewConstraint,
            leftImViewConstraint,
            rightImViewConstraint
            ])
        
        imageView.addConstraints([widthImViewConstraint, heightImViewConstraint])
    }
}

// MARK: Helpers
extension ScrollableImageView {
    
    fileprivate func updateScrollViewForImageChange() {
        if let image = image {
            widthImViewConstraint.constant = image.size.width
            heightImViewConstraint.constant = image.size.height
        }
    }
    
    fileprivate func updateScrollViewContentInset() {
        var viewWidth: CGFloat = 0.0
        var viewHeight: CGFloat = 0.0
        
        if minZoomSize.equalTo(.zero) {
            viewWidth = bounds.size.width
            viewHeight = bounds.size.height
        }
        else {
            viewWidth = minZoomSize.width
            viewHeight = minZoomSize.height
        }
        
        let imageViewRect = imageView.frame
        var contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if imageViewContentInset.top != 0 && imageViewRect.minY < imageViewContentInset.top {
            contentInset.top = imageViewContentInset.top-imageViewRect.minY
        }
        if imageViewContentInset.bottom != 0 && imageViewRect.maxY > viewHeight - imageViewContentInset.bottom {
            contentInset.bottom = imageViewContentInset.bottom+imageViewRect.minY
        }
        if imageViewContentInset.left != 0 && imageViewRect.minX < imageViewContentInset.left {
            contentInset.left = imageViewContentInset.left-imageViewRect.minX
        }
        if imageViewContentInset.right != 0 && imageViewRect.maxX > viewWidth - imageViewContentInset.right {
            contentInset.right = imageViewContentInset.right+imageViewRect.minX
        }
        
        self.contentInset = contentInset;
    }
    
    fileprivate func updateConstraints(forViewSize viewSize: CGSize) {
        let imageSize = image?.size ?? .zero
        
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        var viewWidth: CGFloat = 0.0
        var viewHeight: CGFloat = 0.0
        
        if minZoomSize.equalTo(.zero) {
            viewWidth = viewSize.width
            viewHeight = viewSize.height
        }
        else {
            viewWidth = minZoomSize.width
            viewHeight = minZoomSize.height
        }
        
        // center image if it is smaller than currentViewSize (self.bounds.size or minZoomSize)
        var hPadding = (viewWidth - zoomScale * imageWidth) / 2
        if hPadding < 0 {
            hPadding = 0
        }
        
        var vPadding = (viewHeight - zoomScale * imageHeight) / 2
        if vPadding < 0 {
            vPadding = 0
        }
        
        // Update constraints
        leftImViewConstraint.constant = hPadding
        rightImViewConstraint.constant = hPadding
        topImViewConstraint.constant = vPadding
        bottomImViewConstraint.constant = vPadding
        
        layoutIfNeeded()
        updateScrollViewContentInset()
    }
    
    fileprivate func updateImageScrollViewZoom(forViewSize viewSize: CGSize) {
        let imageSize = image?.size ?? CGSize(width: 1, height: 1)
        
        var minZoom: CGFloat = 0.0
        var maxZoom: CGFloat = 0.0
        
        if minZoomSize.equalTo(.zero) {
            minZoom = min(viewSize.width/imageSize.width, viewSize.height/imageSize.height)
        }
        else {
            minZoom = max(minZoomSize.width/imageSize.width, minZoomSize.height/imageSize.height)
        }
        
        maxZoom = max(1.3, minZoom*1.3)
        
        minimumZoomScale = minZoom
        maximumZoomScale = maxZoom
        
        // Force scrollViewDidZoom fire if zoom did not change
        if minZoom == lastZoomScale {
            minZoom += 0.000001
        }
        
        zoomScale = minZoom
        lastZoomScale = minZoom
    }
}

// MARK: Layout
extension ScrollableImageView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !previousScrollViewFrame.equalTo(frame) {
            previousScrollViewFrame = frame;
            let size = bounds.size;
            updateConstraints(forViewSize: size)
            updateImageScrollViewZoom(forViewSize: size)
        }
    }
}

extension ScrollableImageView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(forViewSize: scrollView.bounds.size)
    }
}



//
//  ImageCropSelectionView.swift
//  Pods
//
//  Created by Robert Magnusson on 2016-10-11.
//
//

import UIKit

public class ImageCropSelectionView: UIView {
    
    fileprivate struct Constants {
        static let MaxMaskHoleDiamater: CGFloat = 320
    }
    
    fileprivate let maskHoleLayer: CAShapeLayer
    fileprivate let maskHoleBorderLayer: CAShapeLayer
    fileprivate let scrollableImageView: ScrollableImageView
    
    fileprivate var maskHoleFrame = CGRect.zero {
        didSet {
            let maskPath = UIBezierPath(rect: bounds)
            let holePath = UIBezierPath(ovalIn: maskHoleFrame)
            maskPath.append(holePath)

            maskHoleLayer.path = maskPath.cgPath
            maskHoleBorderLayer.path = holePath.cgPath
            
            let minXPos = maskHoleFrame.minX
            let minYPos = maskHoleFrame.minY
            scrollableImageView.imageViewContentInset = UIEdgeInsets(top: minYPos, left: minXPos, bottom: minYPos, right: minXPos)
            scrollableImageView.minZoomSize = maskHoleFrame.size
            
            scrollableImageView.centerImageInView()
            scrollableImageView.setImageZoomScaleToAspectFitViewSize()
        }
    }
    
    /**
        Set the image to use in ScrollabelImageView
     */
    public var image: UIImage? {
        didSet {
            scrollableImageView.image = image
        }
    }
    
    public init() {
        maskHoleLayer = CAShapeLayer()
        maskHoleBorderLayer = CAShapeLayer()
        scrollableImageView = ScrollableImageView()
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        maskHoleLayer = CAShapeLayer()
        maskHoleBorderLayer = CAShapeLayer()
        scrollableImageView = ScrollableImageView()
        
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        scrollableImageView.contentInsetAdjustmentBehavior = .never
        addSubview(scrollableImageView)
        
        let maskView = UIView()
        maskView.translatesAutoresizingMaskIntoConstraints = false
        maskView.isUserInteractionEnabled = false
        maskView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        addSubview(maskView)
        
        maskHoleLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskView.layer.mask = maskHoleLayer
        
        maskHoleBorderLayer.lineWidth = 2;
        maskHoleBorderLayer.strokeColor = UIColor.white.cgColor
        maskHoleBorderLayer.fillColor = UIColor.clear.cgColor
        maskHoleBorderLayer.lineCap = CAShapeLayerLineCap.round
        maskHoleBorderLayer.lineJoin = CAShapeLayerLineJoin.round
        maskView.layer.addSublayer(maskHoleBorderLayer)


        let topImViewConstraint = NSLayoutConstraint(item: scrollableImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomImViewConstraint = NSLayoutConstraint(item: scrollableImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftImViewConstraint = NSLayoutConstraint(item: scrollableImageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightImViewConstraint = NSLayoutConstraint(item: scrollableImageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        
        addConstraints([
            topImViewConstraint,
            bottomImViewConstraint,
            leftImViewConstraint,
            rightImViewConstraint
            ])
        
        let topMaskViewConstraint = NSLayoutConstraint(item: maskView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomMaskViewConstraint = NSLayoutConstraint(item: maskView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftMaskViewConstraint = NSLayoutConstraint(item: maskView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightMaskViewConstraint = NSLayoutConstraint(item: maskView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        
        addConstraints([
            topMaskViewConstraint,
            bottomMaskViewConstraint,
            leftMaskViewConstraint,
            rightMaskViewConstraint
            ])
    }
    
    /**
        Returns the cropped image that currently is 
        visible inside the selection area.
     */
    public func croppedSelectionImage() -> UIImage? {
        let cropSelectionFrame = scrollableImageView.convert(maskHoleFrame, from: self)
        return scrollableImageView.imageForFrame(cropSelectionFrame)
    }
}

// MARK: Layout
extension ImageCropSelectionView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewWidth = bounds.width
        let viewHeight = bounds.height
        let holeEdgeMargin: CGFloat = 8
        let holeDiameter = min(Constants.MaxMaskHoleDiamater, min(viewWidth, viewHeight) - 2*holeEdgeMargin)
        
        maskHoleFrame = CGRect(x: viewWidth/2-holeDiameter/2, y: viewHeight/2-holeDiameter/2, width: holeDiameter, height: holeDiameter)
    }
}

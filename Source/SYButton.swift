//
//  SYButton.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

@IBDesignable
public class SYButton: UIButton, AnimatableComponent, TextConvertible {
    
    public enum AnimationType: Int {
        case border, borderWithShadow, background, ripple, text
    }
    
    @IBInspectable public var animationBorderColor: UIColor = AnimationDefaultColor.border {
        didSet {
            syLayer.setAnimationBorderColor(animationBorderColor)
        }
    }
    @IBInspectable public var animationBackgroundColor: UIColor = AnimationDefaultColor.background {
        didSet {
            syLayer.setAnimationBackgroundColor(animationBackgroundColor)
        }
    }
    @IBInspectable public var animationTextColor: UIColor = AnimationDefaultColor.text {
        didSet {
            syLayer.setAnimationTextColor(animationTextColor)
        }
    }
    @IBInspectable public var animationRippleColor: UIColor = AnimationDefaultColor.ripple {
        didSet {
            syLayer.setAnimationRippleColor(animationRippleColor)
        }
    }
    @IBInspectable public var animationTimingAdapter: Int {
        get {
            return animationTimingFunction.rawValue
        }
        set(index) {
            animationTimingFunction = SYMediaTimingFunction(rawValue: index) ?? .linear
        }
    }
    @IBInspectable public var animationDuration: CGFloat = ButtonConstants.defaultDuration {
        didSet {
            syLayer.setAnimationDuration( CFTimeInterval(animationDuration) )
        }
    }
    @IBInspectable public var animationAdapter: Int {
        get {
            return animationType.rawValue
        }
        set(index) {
            animationType = AnimationType(rawValue: index) ?? .border
        }
    }
    
    public var animationTimingFunction: SYMediaTimingFunction = .linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    
    public var animationType: AnimationType = .border {
        didSet {
            syLayer.animationType = {
                switch animationType {
                case .border:
                    return .border
                case .borderWithShadow:
                    return .borderWithShadow
                case .background:
                    return .background
                case .ripple:
                    return .ripple
                case .text:
                    return .text
                }
            }()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            syLayer.resizeSuperLayer()
        }
    }
    override public var frame: CGRect {
        didSet {
            syLayer.resizeSuperLayer()
        }
    }
    override public var backgroundColor: UIColor? {
        didSet {
            guard let backgroundColor = backgroundColor else { return }
            syLayer.setBackgroundColor(backgroundColor)
        }
    }
    
    public var isAnimating = false
    
    var textLayer = CATextLayer()
    
    public var textAlignmentMode: TextAlignmentMode = .center {
        didSet {
            resetTextLayer()
        }
    }
    
    fileprivate lazy var syLayer: SYLayer = SYLayer(sLayer: self.layer)
    
    fileprivate var textColor = UIColor.black {
        didSet {
            syLayer.setTextColor(textColor)
        }
    }
    
    // MARK: - initializer -
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLayer()
    }
    
    // MARK: - Public Methods -
    
    override public func setTitle(_ title: String?, for state: UIControlState) {
        guard let title = title else { return }
        super.setTitle(title, for: state)
        
        resetTextLayer()
    }
    
    override public func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        super.setTitleColor(UIColor.clear, for: state)
        
        guard let color = color else { return }
        textLayer.foregroundColor = color.cgColor
        textColor = color
    }
    
    public func setFontOfSize(_ fontSize: CGFloat) {
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        resetTextLayer()
    }
    
    public func setFontNameWithSize(_ name: String, size: CGFloat) {
        guard let titleLabel = titleLabel else { return }
        
        titleLabel.font = UIFont(name: name, size: size)
        resetTextLayer()
    }
    
    public func startAnimation() {
        isAnimating = true
        syLayer.startAnimation()
    }
    
    public func stopAnimation() {
        isAnimating = false
        syLayer.stopAnimation()
    }
}

// MARK: - Fileprivate Methods -

fileprivate extension SYButton {
    
    struct ButtonConstants {
        static let cornerRadius: CGFloat    = 5
        static let padding: CGFloat         = 5
        static let defaultDuration: CGFloat = 1
    }
    
    func setLayer() {
        layer.cornerRadius = ButtonConstants.cornerRadius
        contentEdgeInsets  = UIEdgeInsets(top: ButtonConstants.padding, left: ButtonConstants.padding, bottom: ButtonConstants.padding, right: ButtonConstants.padding)
        
        syLayer.animationType = .border

        setTitleColor(UIColor.black, for: UIControlState())
    }
    
    func resetTextLayer() {
        configureTextLayer(currentTitle, font: titleLabel?.font, textColor: textColor)
        syLayer.resetTextLayer(textLayer)
    }
}

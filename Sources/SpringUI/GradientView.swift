//
//  GradientView.swift
//  
//
//  Created by hengyu on 2020/8/16.
//

//
//  GradientView.swift
//
//  Created by Mathieu Vandeginste on 06/12/2016.
//  Copyright © 2018 Mathieu Vandeginste. All rights reserved.
//

import UIKit

@IBDesignable
public final class GradientView: UIView {

    private var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }

    @IBInspectable
    public var topColor: UIColor = .red {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var bottomColor: UIColor = .yellow {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var shadowColor: UIColor = .clear {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var shadowX: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var shadowY: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var shadowBlur: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var startPointX: CGFloat = 0.5 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var startPointY: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var endPointX: CGFloat = 0.5 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var endPointY: CGFloat = 1 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    public override func layoutSubviews() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)

        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        layer.shadowRadius = shadowBlur
        layer.shadowOpacity = 1

        super.layoutSubviews()
    }

    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = gradientLayer.colors
        let toColors = [newTopColor.cgColor, newBottomColor.cgColor]
        gradientLayer.colors = toColors

        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)

        gradientLayer.add(animation, forKey: "animateGradient")
    }
}

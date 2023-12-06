//
//  MIT LICENSE
//
//  Created by hengyu on 2020/8/16.
//  Copyright © 2020-2023 hengyu. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

@IBDesignable
public final class GradientView: UIView {

    // swiftlint:disable force_cast
    private var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    // swiftlint:enable force_cast

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

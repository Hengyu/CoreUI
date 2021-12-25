//
//  RoundedButton.swift
//  
//
//  Created by hengyu on 2020/8/16.
//

import UIKit

// MARK: - RoundedButton

@IBDesignable
public final class RoundedButton: UIButton {

    private var _canBecomeFocused: Bool = false

    public func setCanBecomeFocused(_ focused: Bool) {
        _canBecomeFocused = focused
    }

    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }

//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        var new = super.sizeThatFits(size)
//        new.width += 2 * cornerRadius
//        return new
//    }

    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.width > 0 {
            size.width += 2 * cornerRadius
        }
        return size
    }

    public override var canBecomeFocused: Bool {
        _canBecomeFocused
    }
}

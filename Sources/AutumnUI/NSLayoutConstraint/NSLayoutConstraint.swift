//
//  NSLayoutConstraint.swift
//  
//
//  Created by hengyu on 2020/8/17.
//

import UIKit

extension NSLayoutConstraint {

    public func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

extension NSLayoutConstraint.Attribute {

    public func withoutMargin() -> NSLayoutConstraint.Attribute {
        switch self {
        case .left, .right, .top, .bottom, .leading, .trailing,
             .width, .height, .centerX, .centerY,
             .lastBaseline, .firstBaseline, .notAnAttribute:
            return self
        case .leftMargin:
            return .left
        case .rightMargin:
            return .right
        case .topMargin:
            return .top
        case .bottomMargin:
            return .bottom
        case .leadingMargin:
            return .leading
        case .trailingMargin:
            return .trailing
        case .centerXWithinMargins:
            return .centerX
        case .centerYWithinMargins:
            return .centerY
        @unknown default:
            return self
        }
    }
}

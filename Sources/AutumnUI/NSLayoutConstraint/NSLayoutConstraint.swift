//
//  MIT LICENSE
//
//  Created by hengyu on 2020/8/17.
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

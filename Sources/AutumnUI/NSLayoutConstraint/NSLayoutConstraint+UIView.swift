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

extension UIView {

    @discardableResult
    @MainActor
    public func constrainToSuperview(
        anchors: Set<NSLayoutConstraint.Attribute> = [.top, .leading, .bottom, .trailing],
        priority: UILayoutPriority = .required,
        shouldActivate: Bool = true) -> [NSLayoutConstraint.Attribute: NSLayoutConstraint]
    {
        guard let superview else {
            assertionFailure("The view does not have a superview and cannot be constrainted")
            return [:]
        }

        let results = constrain(to: superview, anchors: anchors, priority: priority, shouldActivate: shouldActivate)
        return results
    }

    @discardableResult
    @MainActor
    public func constrainToSuperview(
        anchor: NSLayoutConstraint.Attribute,
        priority: UILayoutPriority = .required,
        shouldActivate: Bool = true) -> NSLayoutConstraint
    {
        guard let superview else {
            assertionFailure("The view does not have a superview and cannot be constrainted")
            return NSLayoutConstraint()
        }

        let result = constrain(to: superview, anchor: anchor, priority: priority, shouldActivate: shouldActivate)
        return result
    }

    @discardableResult
    @MainActor
    public func constrain(
        to view: UIView,
        anchor: NSLayoutConstraint.Attribute,
        priority: UILayoutPriority = .required,
        shouldActivate: Bool = true) -> NSLayoutConstraint
    {
        let result = constrain(to: view, anchors: [anchor], priority: priority, shouldActivate: shouldActivate)
        guard let constraint = result[anchor] else {
            assertionFailure("Expected to have a constraint related to anchor \(anchor)")
            return NSLayoutConstraint()
        }
        return constraint
    }

    @discardableResult
    @MainActor
    public func constrain(
        to view: UIView,
        anchors: Set<NSLayoutConstraint.Attribute> = [.top, .leading, .bottom, .trailing],
        priority: UILayoutPriority = .required,
        shouldActivate: Bool = true) -> [NSLayoutConstraint.Attribute: NSLayoutConstraint]
    {
        assert(!anchors.contains(.notAnAttribute), "Cannot setup a constraint between two attributes of type `.notAnAttribute`")

        let initialValue: [NSLayoutConstraint.Attribute: NSLayoutConstraint] = [:]
        let constraints = anchors.reduce(initialValue) { result, anchor in
            var result = result
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: anchor.withoutMargin(),
                relatedBy: .equal,
                toItem: view,
                attribute: anchor,
                multiplier: 1,
                constant: 0)
            constraint.priority = priority
            result[anchor] = constraint
            return result
        }

        if shouldActivate {
            NSLayoutConstraint.activate(Array(constraints.values))
        }

        return constraints
    }
}

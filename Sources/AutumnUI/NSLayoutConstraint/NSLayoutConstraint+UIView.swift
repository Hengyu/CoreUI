//
//  NSLayoutConstraint+UIView.swift
//  
//
//  Created by hengyu on 2020/8/17.
//

import UIKit

extension UIView {

    @discardableResult
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

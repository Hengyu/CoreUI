//
//  UIViewController.swift
//  ChessBot
//
//  Created by hengyu on 2018/11/9.
//  Copyright © 2018 hengyu. All rights reserved.
//

import UIKit

// MARK: - Layout information

public enum UIOrientation {
    case portrait
    case landscape

    public init(size: CGSize) {
        if size.width > size.height {
            self = .landscape
        } else {
            self = .portrait
        }
    }
}

public struct UILayoutInformation {
    public var orientation: UIOrientation
    public var traitCollection: UITraitCollection {
        get { _traitCollection }
        set { _traitCollection = UITraitCollection(traitsFrom: [newValue]) }
    }

    private var _traitCollection: UITraitCollection

    public init(orientation: UIOrientation, traitCollection: UITraitCollection) {
        self.orientation = orientation
        _traitCollection = traitCollection
    }
}

// MARK: - Navigation bar

public enum UINavigationBarStyle {
    case regular
    case compact
    case hidden
}

extension UINavigationController {

    public func setNavigationBarStyle(_ style: UINavigationBarStyle) {
        switch style {
        case .regular:
            setNavigationBarHidden(false, animated: false)
            #if os(iOS) || os(OSX)
            if #available(iOS 11.0, *) {
                navigationBar.prefersLargeTitles = true
            }
            #endif
        case .hidden:
            setNavigationBarHidden(true, animated: false)
            #if os(iOS) || os(OSX)
            if #available(iOS 11.0, *) {
                navigationBar.prefersLargeTitles = false
            }
            #endif
        default:
            setNavigationBarHidden(false, animated: false)
            #if os(iOS) || os(OSX)
            if #available(iOS 11.0, *) {
                navigationBar.prefersLargeTitles = false
            }
            #endif
        }
    }
}

extension UIViewController {

    public func setNavigationLargeTitleEnabled(_ enabled: Bool) {
        #if os(iOS) || os(OSX)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = enabled ? .always : .never
        }
        #endif
    }
}

// MARK: - Layout margins

extension UIViewController {

    var horizontalMargin: CGFloat {
        switch traitCollection.userInterfaceIdiom {
        case .pad:
            if view.bounds.width > view.bounds.height {
                return traitCollection.horizontalSizeClass == .regular ? 100 : 20
            } else {
                return traitCollection.horizontalSizeClass == .regular ? 80 : 20
            }
        case .tv:
            if view.bounds.width > view.bounds.height {
                return traitCollection.horizontalSizeClass == .regular ? 180 : 20
            } else {
                return traitCollection.horizontalSizeClass == .regular ? 120 : 20
            }
        default:
            return traitCollection.horizontalSizeClass == .regular ? 60 : 20
        }
    }

    public func setNeedsUpdateLayoutMargins() {
        if #available(iOS 11.0, tvOS 11.0, *) {
            if let navigationController = navigationController {
//                navigationController.navigationBar.directionalLayoutMargins.leading = horizontalMargin
//                navigationController.navigationBar.directionalLayoutMargins.trailing = horizontalMargin
                var navDirectionalMargins = navigationController.navigationBar.directionalLayoutMargins
                navDirectionalMargins.leading = horizontalMargin
                navDirectionalMargins.trailing = horizontalMargin
                navigationController.navigationBar.directionalLayoutMargins = navDirectionalMargins
            }

//            view?.directionalLayoutMargins.leading = horizontalMargin
//            view?.directionalLayoutMargins.trailing = horizontalMargin

            // TL;DR: The code above may leads UI inconsistency, so we commented it.

            // If we set each components of the view's `directionalMargins` separately,
            // an UI inconsistency may occur if the willSet value is smaller than
            // the corresponding component of the `safeAreaInsets`.
            // E.g., For iPhone X, the value for bottom component of its `safeAreaInsets` is 106,
            // and this value is identical for `directionalLayoutMargins`'s bottom component.
            // If we do `view.directionalLayoutMargins.bottom = x`,
            // x is some value smaller than 106,
            // this line of code will have no effects.
            // We may fix this by setting `self.viewRespectsSystemMinimumLayoutMargins` to `false`.

            var directionalMargins = view.directionalLayoutMargins
            directionalMargins.leading = horizontalMargin
            directionalMargins.trailing = horizontalMargin
            view.directionalLayoutMargins = directionalMargins
        } else {
            // Before iOS 11, the large title display mode was not introduced.
            // So we do not need to take care of the `navigationController.navigationBar`
            view?.layoutMargins.left = horizontalMargin
            view?.layoutMargins.right = horizontalMargin
        }
    }

    func populateLayoutMarginsIfNeeded() {

        func populateSubviews(in view: UIView) {
            for subview in view.subviews where subview.preservesSuperviewLayoutMargins {
                subview.layoutMargins = view.layoutMargins
                populateSubviews(in: subview)
            }
        }

        populateSubviews(in: view)
    }
}

// MARK: - Dismiss & Go back

extension UIViewController {

    private struct AssociatedKeys {
        static var activatesEscapeKeyCommand: String = "activatesEscapeKeyCommand"
    }

    public var activatesEscapeKeyCommand: Bool {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.activatesEscapeKeyCommand) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activatesEscapeKeyCommand, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    open override var keyCommands: [UIKeyCommand]? {
        if activatesEscapeKeyCommand {
            let esc = UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: UIKeyModifierFlags(rawValue: 0), action: #selector(escapeKeyPressed(_:)))
            return [esc] + (super.keyCommands ?? [])
        } else {
            return super.keyCommands
        }
    }

    public func removeFromPresentingStack(animated: Bool = true) {
        if let nav = navigationController {
            if nav.viewControllers.first !== self {
                nav.popViewController(animated: animated)
            } else {
                nav.presentingViewController?.dismiss(animated: animated, completion: nil)
            }
        } else {
            presentingViewController?.dismiss(animated: animated, completion: nil)
        }
    }

    @objc
    open func escapeKeyPressed(_ keyCommand: UIKeyCommand) {
        removeFromPresentingStack()
    }
}

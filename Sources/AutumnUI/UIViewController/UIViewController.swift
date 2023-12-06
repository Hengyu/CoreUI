//
//  MIT LICENSE
//
//  Created by hengyu on 2018/11/9.
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

// MARK: - Layout information

public enum UIOrientation: Codable, CaseIterable, Equatable, Sendable {
    case portrait
    case landscape

    public init(size: CGSize) {
        if size.width > size.height {
            self = .landscape
        } else {
            self = .portrait
        }
    }

    public static var allCases: [UIOrientation] {
        [.portrait, .landscape]
    }
}

public struct UILayoutInformation: Equatable, Sendable {
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

public enum UINavigationBarStyle: CaseIterable, Codable, Equatable, Sendable {
    case regular
    case compact
    case hidden

    public static var allCases: [UINavigationBarStyle] {
        [.regular, .compact, .hidden]
    }
}

extension UINavigationController {

    @MainActor
    public func setNavigationBarStyle(_ style: UINavigationBarStyle) {
        switch style {
        case .regular:
            setNavigationBarHidden(false, animated: false)
            #if os(iOS) || os(OSX)
            navigationBar.prefersLargeTitles = true
            #endif
        case .hidden:
            setNavigationBarHidden(true, animated: false)
            #if os(iOS) || os(OSX)
            navigationBar.prefersLargeTitles = false
            #endif
        default:
            setNavigationBarHidden(false, animated: false)
            #if os(iOS) || os(OSX)
            navigationBar.prefersLargeTitles = false
            #endif
        }
    }
}

extension UIViewController {

    @MainActor
    public func setNavigationLargeTitleEnabled(_ enabled: Bool) {
        #if os(iOS) || os(OSX)
        navigationItem.largeTitleDisplayMode = enabled ? .always : .never
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

    @MainActor
    public func setNeedsUpdateLayoutMargins() {
        if let navigationController {
            var navDirectionalMargins = navigationController.navigationBar.directionalLayoutMargins
            navDirectionalMargins.leading = horizontalMargin
            navDirectionalMargins.trailing = horizontalMargin
            navigationController.navigationBar.directionalLayoutMargins = navDirectionalMargins
        }

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
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.activatesEscapeKeyCommand,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            if activatesEscapeKeyCommand {
                let esc = UIKeyCommand(
                    input: UIKeyCommand.inputEscape,
                    modifierFlags: UIKeyModifierFlags(rawValue: 0),
                    action: #selector(escapeKeyPressed(_:))
                )
                if #available(iOS 15.0, macCatalyst 15.0, tvOS 15.0, *) {
                    esc.wantsPriorityOverSystemBehavior = true
                }
                addKeyCommand(esc)
            } else {
                if let command = keyCommands?.first(
                    where: { $0.action == #selector(escapeKeyPressed(_:)) && $0.input == UIKeyCommand.inputEscape }
                ) {
                    removeKeyCommand(command)
                }
            }
        }
    }

    public func removeFromPresentingStack(animated: Bool = true) {
        if let navigationController {
            if navigationController.viewControllers.first !== self {
                navigationController.popViewController(animated: animated)
            } else {
                navigationController.presentingViewController?.dismiss(animated: animated, completion: nil)
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

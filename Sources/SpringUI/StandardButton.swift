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

#if canImport(AutumnUI)
import AutumnUI
#endif
import UIKit

// MARK: - StandardButtonContent

public struct StandardButtonContent: Equatable, Hashable, Sendable {
    public let text: String?
    public let image: UIImage?
    public let accessibilityLabel: String?
    public let accessibilityHint: String?

    public init(text: String?, image: UIImage?, accessibilityLabel: String?, accessibilityHint: String?) {
        self.text = text
        self.image = image
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
    }
}

// MARK: - StandardButtonStyle

public struct StandardButtonStyle: Equatable, Sendable {
    public var contentInset: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
    public var cornerRadius: CGFloat = 12
    public var backgroundColor: UIColor = .actionBackground
    public var textColor: UIColor = .init(red: 63 / 255.0, green: 120 / 255.0, blue: 184 / 255.0, alpha: 1)
    public var textFont: UIFont = .preferredFont(forTextStyle: .headline)
    #if canImport(AutumnUI)
    public var enablePressAnimation: Bool = true
    #endif

    private init() { }
}

extension StandardButtonStyle {
    public static let standard: StandardButtonStyle = .init()

    public static let disabled: StandardButtonStyle = {
        var style: StandardButtonStyle = .standard
        style.textColor = .systemGray
        #if canImport(AutumnUI)
        style.enablePressAnimation = false
        #endif
        return style
    }()
}

// MARK: - StandardButton

public final class StandardButton: UIButton {

    private let style: StandardButtonStyle
    private var _canBecomeFocused: Bool = false

    public var text: String? {
        get { title(for: .normal) }
        set { setTitle(newValue, for: .normal)}
    }

    public var textColor: UIColor? {
        get { titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal)}
    }

    public var image: UIImage? {
        get { image(for: .normal) }
        set { setImage(newValue, for: .normal) }
    }

    public override var canBecomeFocused: Bool {
        _canBecomeFocused
    }

    public override init(frame: CGRect) {
        style = .standard
        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        style = .standard
        super.init(coder: coder)
        commonInit()
    }

    public init(style: StandardButtonStyle) {
        self.style = style
        super.init(frame: .zero)
        commonInit()
    }

    public func setCanBecomeFocused(_ focused: Bool) {
        _canBecomeFocused = focused
    }

    public func applyStyle(_ style: StandardButtonStyle) {
        contentEdgeInsets = style.contentInset
        layer.cornerRadius = style.cornerRadius
        backgroundColor = style.backgroundColor
        titleLabel?.font = style.textFont
        textColor = style.textColor
    }

    private func commonInit() {
        applyStyle(style)
        setupActionHandlers()
    }

    private func setupActionHandlers() {
        addTarget(
            self,
            action: #selector(didUnhighlight(_:)),
            for: [.touchUpInside, .touchDragExit, .touchUpOutside, .touchCancel]
        )
        addTarget(
            self,
            action: #selector(didHighlight(_:)),
            for: [.touchDragEnter, .touchDown]
        )
    }

    @objc
    private func didHighlight(_ button: UIButton) {
        #if canImport(AutumnUI)
        if style.enablePressAnimation {
            animatePressDown()
        }
        #endif
    }

    @objc
    private func didUnhighlight(_ button: UIButton) {
        #if canImport(AutumnUI)
        if style.enablePressAnimation {
            animatePressUp()
        }
        #endif
    }
}

extension StandardButton {

    @MainActor
    public var content: StandardButtonContent {
        .init(text: text, image: image, accessibilityLabel: accessibilityLabel, accessibilityHint: accessibilityHint)
    }

    @MainActor
    public func setContent(_ content: StandardButtonContent) {
        text = content.text
        image = content.image
        accessibilityLabel = content.accessibilityLabel
        accessibilityHint = content.accessibilityHint
    }
}

extension UIColor {

    fileprivate class var actionBackground: UIColor {
        if #available(iOS 13.0, tvOS 13.0, *) {
            #if os(tvOS)
            return .separator
            #else
            return .tertiarySystemGroupedBackground
            #endif
        } else {
            #if os(tvOS)
            return .systemGray
            #else
            return .groupTableViewBackground
            #endif
        }
    }
}

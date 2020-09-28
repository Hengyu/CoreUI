//
//  StandardButton.swift
//
//
//  Created by hengyu on 2020/8/17.
//  Copyright © 2020 hengyu. All rights reserved.
//

#if canImport(AutumnUI)
import AutumnUI
#endif
import UIKit

public struct StandardButtonStyle {
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
}

public final class StandardButton: UIButton {

    private let style: StandardButtonStyle

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

    private func commonInit() {
        applyStyle(style)
        setupActionHandlers()
    }

    private func setupActionHandlers() {
        addTarget(self, action: #selector(didUnhighlight(_:)), for: [.touchUpInside, .touchDragExit, .touchUpOutside, .touchCancel])
        addTarget(self, action: #selector(didHighlight(_:)), for: [.touchDragEnter, .touchDown])
    }

    private func applyStyle(_ style: StandardButtonStyle) {
        contentEdgeInsets = style.contentInset
        layer.cornerRadius = style.cornerRadius
        backgroundColor = style.backgroundColor
        titleLabel?.font = style.textFont
        textColor = style.textColor
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

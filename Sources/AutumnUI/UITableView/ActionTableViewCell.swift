//
//  MIT LICENSE
//
//  Created by hengyu on 2017/8/13.
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

public protocol TitleConfigurable: AnyObject {
    var titleText: String? { get set }
}

public final class ActionTableViewCell: UITableViewCell, TitleConfigurable {

    public var titleText: String? {
        get { _titleText }
        set {
            _titleText = newValue
            if #available(iOS 14.0, macCatalyst 14.0, tvOS 14.0, *) {
                updateTitleText(hasUnderline: UIAccessibility.buttonShapesEnabled)
            } else {
                textLabel?.text = newValue
            }
        }
    }

    public var image: UIImage? {
        get { imageView?.image }
        set { imageView?.image = newValue }
    }

    public override var canBecomeFocused: Bool {
        true
    }

    public override var isAccessibilityElement: Bool {
        get { true }
        set { _ = newValue }
    }

    public override var accessibilityLabel: String? {
        get { _titleText }
        set { _ = newValue }
    }

    private var _titleText: String?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        selectionStyle = .default
        #if os(iOS) || targetEnvironment(macCatalyst)
        textLabel?.textColor = UIColor.lightBlue
        #endif

        if #available(iOS 14.0, macCatalyst 14.0, tvOS 14.0, *) {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(buttonShapesEnabledStatusDidChange(_:)),
                name: UIAccessibility.buttonShapesEnabledStatusDidChangeNotification,
                object: nil
            )
        }
    }

    @objc
    @available(iOS 14.0, macCatalyst 14.0, tvOS 14.0, *)
    private func buttonShapesEnabledStatusDidChange(_ notification: Notification) {
        updateTitleText(hasUnderline: UIAccessibility.buttonShapesEnabled)
    }

    private func updateTitleText(hasUnderline: Bool) {
        guard let _titleText else {
            textLabel?.text = nil
            textLabel?.attributedText = nil
            return
        }

        if hasUnderline {
            textLabel?.text = nil
            textLabel?.attributedText = NSAttributedString(
                string: _titleText,
                attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
            )
        } else {
            textLabel?.attributedText = nil
            textLabel?.text = _titleText
        }
    }
}

public final class SubtitleTableViewCell: UITableViewCell, TitleConfigurable {

    public var titleText: String? {
        get { textLabel?.text }
        set { textLabel?.text = newValue }
    }

    public var subtitleText: String? {
        get { detailTextLabel?.text }
        set { detailTextLabel?.text = newValue }
    }

    public var image: UIImage? {
        get { imageView?.image }
        set { imageView?.image = newValue }
    }

    public override var canBecomeFocused: Bool {
        true
    }

    public override var isAccessibilityElement: Bool {
        get { true }
        set { _ = newValue }
    }

    public override var accessibilityLabel: String? {
        get { titleText }
        set { _ = newValue }
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

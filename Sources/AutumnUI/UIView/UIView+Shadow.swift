//
//  MIT LICENSE
//
//  Created by hengyu on 2020/9/27.
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

public struct ShadowStyle: Equatable, Sendable {
    public let color: UIColor
    public let radius: CGFloat
    public let opacity: Float
}

extension ShadowStyle {

    public static let mediumGray: ShadowStyle = .init(color: .init(white: 0.4, alpha: 1), radius: 10, opacity: 0.8)
    public static let noShadow: ShadowStyle = .init(color: .white, radius: 0, opacity: 0)
}

extension UIView {

    @MainActor
    public func applyShadowStyle(_ style: ShadowStyle) {
        layer.shadowColor = style.color.cgColor
        layer.shadowRadius = style.radius
        layer.shadowOpacity = style.opacity
    }

    @MainActor
    public func removeShadowStyle() {
        applyShadowStyle(.noShadow)
    }
}

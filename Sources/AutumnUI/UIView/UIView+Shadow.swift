//
//  UIView+Shadow.swift
//  
//
//  Created by hengyu on 2020/9/27.
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

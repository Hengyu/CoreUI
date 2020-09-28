//
//  UIActivityIndicatorView.swift
//  ChessBot
//
//  Created by hengyu on 2019/8/3.
//  Copyright © 2019 hengyu. All rights reserved.
//

import UIKit.UIActivityIndicatorView

extension UIActivityIndicatorView {

    public enum UniStyle {
        case compact
        case regular
    }

    public convenience init(uniStyle: UniStyle) {
        if #available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *) {
            if uniStyle == .compact {
                self.init(style: .medium)
            } else {
                self.init(style: .large)
            }
        } else {
            if uniStyle == .compact {
                self.init(style: .white)
            } else {
                self.init(style: .whiteLarge)
            }
        }
    }
}

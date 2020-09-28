//
//  UITableViewController.swift
//  ChessBot
//
//  Created by hengyu on 2020/5/5.
//  Copyright © 2020 hengyu. All rights reserved.
//

import UIKit

extension UITableViewController {

    public enum CompatibleStyle {
        case insetGrouped
        case grouped
        case plain

        var style: UITableView.Style {
            switch self {
            case .insetGrouped:
                #if os(tvOS)
                fallthrough
                #else
                if #available(iOS 13.0, macCatalyst 13.0, *) {
                    return .insetGrouped
                } else {
                    fallthrough
                }
                #endif
            case .grouped:
                return .grouped
            case .plain:
                return .plain
            }
        }
    }

    public convenience init(compatibleStyle: CompatibleStyle) {
        self.init(style: compatibleStyle.style)
    }
}

//
//  ActionTableViewCell.swift
//  ChessBot
//
//  Created by hengyu on 2017/8/13.
//  Copyright © 2017年 hengyu. All rights reserved.
//

import UIKit

public final class ActionTableViewCell: UITableViewCell {
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
        #if os(iOS) || os(OSX)
        textLabel?.textColor = UIColor.lightBlue
        #endif
    }
}

public final class SubtitleTableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

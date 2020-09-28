//
//  RoundedLabel.swift
//  
//
//  Created by hengyu on 2020/8/16.
//

import UIKit

public final class RoundedLabel: UILabel {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        textAlignment = .center
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.masksToBounds = true
        textAlignment = .center
    }

    @IBInspectable
    public var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }

    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.width > 0 {
            size.width += 2 * cornerRadius
        }
        return size
    }
}

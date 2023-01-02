//
//  NilContentTableFooterView.swift
//  ChessBot
//
//  Created by hengyu on 2017/11/24.
//  Copyright © 2017年 hengyu. All rights reserved.
//

import UIKit

public final class NilContentView: UIView {

    public var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    public var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    private let imageView: UIImageView = .init()
    private let label: UILabel = .init()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        label.textAlignment = .center
        if #available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *) {
            label.textColor = .systemGray
        } else {
            label.textColor = .darkGray
        }
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        let cons0 = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let cons1 = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -50)
        let cons2 = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100)
        let cons3 = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100)
        let cons4 = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let cons5 = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 10)
        let cons6 = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 0)

        NSLayoutConstraint.activate([cons0, cons1, cons2, cons3, cons4, cons5, cons6])
    }
}

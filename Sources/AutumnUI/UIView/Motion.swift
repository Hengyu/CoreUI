//
//  Motion.swift
//  
//
//  Created by hengyu on 2020/8/20.
//

import Foundation
import UIKit

public enum Motion { }

extension Motion {

    public enum Duration { }
    public enum Spring { }
}

extension Motion.Duration {

    public static let short: TimeInterval = 0.2
    public static let regular: TimeInterval = 0.3
    public static let long: TimeInterval = 0.7
    public static let systemHighlight: TimeInterval = regular
    public static let systemUnhighlight: TimeInterval = 0.1
}

extension Motion.Duration {

    public static let damping: CGFloat = 1
    public static let initialVelocity: CGFloat = 1
}

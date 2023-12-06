//
//  MIT LICENSE
//
//  Created by hengyu on 16/3/7.
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

extension UIColor {
    public class var flatGreen: UIColor {
        UIColor(rgbValue: 0x2ECC71)
    }
    public class var flatBlue: UIColor {
        UIColor(rgbValue: 0x3498DB)
    }
    public class var flatPurple: UIColor {
        UIColor(rgbValue: 0x9B59B6)
    }
    public class var flatBlack: UIColor {
        UIColor(rgbValue: 0x141414)
    }
    public class var midnightBlue: UIColor {
        UIColor(rgbValue: 0x2C3E50)
    }
    public class var flatRed: UIColor {
        UIColor(rgbValue: 0xE74C3C)
    }
    public class var flatWhite: UIColor {
        UIColor(rgbValue: 0xECF0F1)
    }
    public class var lightBlue: UIColor {
        UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
    }
    public class var flatOrange: UIColor {
        UIColor(red: 249/255.0, green: 160.0/255.0, blue: 69/255.0, alpha: 1)
    }
    public class var flatGold: UIColor {
        UIColor(red: 213/255.0, green: 172/255.0, blue: 59/255.0, alpha: 1)
    }
    public class var meditation: UIColor {
        UIColor(red: 245/255.0, green: 247/255.0, blue: 251/255.0, alpha: 1)
    }
    public class var defaultBackground: UIColor {
        #if os(tvOS)
        .clear
        #else
        .systemBackground
        #endif
    }
    public class var defaultTableViewBackground: UIColor {
        #if os(tvOS)
        .separator
        #else
        .systemGroupedBackground
        #endif
    }
    public class var defaultCellSeparatorColor: UIColor {
        #if os(tvOS)
        .separator
        #else
        .systemGroupedBackground
        #endif
    }
    public class var defaultIndicator: UIColor {
        #if os(tvOS)
        .separator
        #else
        .systemBackground
        #endif
    }

    public class var defaultSecondaryLabel: UIColor {
        #if os(tvOS)
        .secondaryLabel
        #else
        .darkGray
        #endif
    }

    /// Initialize a `UIColor` instance with the given RGB value (hex value).
    ///
    /// - Parameter rgbValue: The hex value of a color.
    convenience init(rgbValue: Int) {
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgbValue & 0xFF00) >> 8)/255.0,
            blue: CGFloat(rgbValue & 0xFF)/255.0,
            alpha: 1
        )
    }

    // swiftlint:disable identifier_name

    /// Create a color with given r, g, b while alpha is 1.
    /// - Parameters:
    ///   - r: Red value.
    ///   - g: Green value.
    ///   - b: Blue value.
    public convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }

    // swiftlint:enable identifier_name

    /**
     UIColor to hex string.
     
     - returns: Hex string of a color.
     */
    public var hexString: String? {
        let color = self.cgColor
        let numComponents = color.numberOfComponents
        if numComponents == 4 {
            let components = color.components
            let red = Int((components?[0])! * 255)
            let green = Int((components?[1])! * 255)
            let blue = Int((components?[2])! * 255)
            let redStr = NSString(format: "%2X", red) as String
            let greenStr = NSString(format: "%2X", green) as String
            let blueStr = NSString(format: "%2X", blue) as String
            return redStr + greenStr + blueStr
        } else {
            return nil
        }
    }
}

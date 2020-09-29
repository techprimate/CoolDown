//
//  NSMutableAttributedString+Operators.swift
//  CoolDownAtributedString
//
//  Created by Philip Niedertscheider on 29.09.20.
//  Copyright © techprimate GmbH & Co. KG 2020. All Rights Reserved!
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let mutable = NSMutableAttributedString(attributedString: lhs)
    mutable.append(rhs)
    return mutable
}

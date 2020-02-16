//
//  StretchyHeaderAttributes.swift
//  MSZ-TwitterLayout
//
//  Created by MSZ on 2/8/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

import Foundation
import UIKit
class StretchyHeaderAttributes: UICollectionViewLayoutAttributes {

    var deltaY: CGFloat = 0
    var deltaYContentOffsetToHeaderHeight: CGFloat = 0
    var deltaYForNavBar: CGFloat = 0

    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! StretchyHeaderAttributes
        copy.deltaY = deltaY
        copy.deltaYForNavBar = deltaYForNavBar
        copy.deltaYContentOffsetToHeaderHeight = deltaYContentOffsetToHeaderHeight
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? StretchyHeaderAttributes {
            if attributes.deltaY == deltaY  &&  attributes.deltaYForNavBar == deltaYForNavBar{
                return super.isEqual(object)
            }
        }
        return false
    }
}

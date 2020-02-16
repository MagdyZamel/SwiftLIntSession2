//
//  CircleCell.swift
//  MSZCircleLayout
//
//  Created by MSZ on 2/14/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

import UIKit

class CircleCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!

}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

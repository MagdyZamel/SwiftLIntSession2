//
//  UserInfoCell.swift
//  MSZ-TwitterLayout
//
//  Created by MSZ on 11/22/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import UIKit

class UserInfoCell: UICollectionViewCell {
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageleadingConstraint: NSLayoutConstraint!
    
    var lastImageWidthConstraint:CGFloat = 0.0
    
    @IBOutlet weak var useriamge:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.useriamge.layer.cornerRadius =  40/2
        self.useriamge.layer.borderColor =  backgroundColor!.cgColor
        self.useriamge.layer.borderWidth =  2
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attributes = layoutAttributes as! StretchyHeaderAttributes

        let ratio = attributes.deltaYForNavBar/attributes.deltaY
        // min width = 40
        let width = (1+ratio) * 40

        if lastImageWidthConstraint  != width {
            lastImageWidthConstraint = width
            imageWidthConstraint.constant = width

            // max height = 80
            imageTopConstraint.constant = -(ratio) * 0.35 * 80 //  0.35 1/3 el height after scalling

            // 18 + 8  =  26 total after min width
            // 8 for maxwidth
            imageleadingConstraint.constant = ((1-ratio) * 18) + 8
            useriamge.layer.cornerRadius =  imageWidthConstraint.constant/2

        }
        
        
    }
}

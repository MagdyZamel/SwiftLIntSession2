//
//  PuppyCell.swift
//  MSZ-TwitterLayout
//
//  Created by MSZ on 11/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import UIKit

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
class PuppyCell: UICollectionViewCell {

    @IBOutlet weak var puppyImage: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        puppyImage.image = nil
    }
    
    func config(with puppy: Int) {
        if let image = UIImage(named: "\(puppy)") {
            puppyImage.image = image

        }else{
            puppyImage.image = #imageLiteral(resourceName: "22")
        }
    }
}

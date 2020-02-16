//
//  ViewController.swift
//  MSZCircleLayout
//
//  Created by MSZ on 2/12/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource {

    @IBOutlet weak var mszCollectionView: UICollectionView!
    @IBOutlet weak var numberOfCircles: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfCircles.text = "16"
        mszCollectionView.collectionViewLayout = CircleLayout()
    }


    @IBAction func drawCollectionView() {
        if let numberOfCircles = Int(numberOfCircles.text ?? "" ){
            mszCollectionView.collectionViewLayout.invalidateLayout()
            mszCollectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfCircles = Int(numberOfCircles.text ?? "" ){
            return numberOfCircles
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CircleCell
        let layout  = collectionView.collectionViewLayout as! CircleLayout
        cell.contentView.backgroundColor  = UIColor.random()
        cell.contentView.layer.cornerRadius = layout.rInnerCircle 
        cell.contentView.layer.masksToBounds = true
        cell.cellLabel.text = "\(indexPath.row)"
        return cell
    }

}

class CircleLayout: UICollectionViewLayout {

    var cachedCellsAttributes = [UICollectionViewLayoutAttributes]()
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        return collectionView.frame.size
    }
    var rInnerCircle: CGFloat = 0.0
    override func prepare() {
        cachedCellsAttributes.removeAll()
        guard let collectionView = collectionView else {
            return
        }
        guard let dataSource = collectionView.dataSource else {
            fatalError("collectionView need to confirm on dataSource")
        }
        var rOuterCircle = collectionView.bounds.width/2
        let numberOfItems  = CGFloat(dataSource.collectionView(collectionView, numberOfItemsInSection: 0))
        if numberOfItems <= 0 {
            return
        }
        let zetaForInnerCircle = (360/numberOfItems) // (CGFloat.pi*2/numberOfItems)/2
        let up = rOuterCircle*sin(degrees: zetaForInnerCircle)
        let bottom = sin(degrees: zetaForInnerCircle) + (2*(sin(degrees: 90-(zetaForInnerCircle/2))))

        if numberOfItems == 2 {
            rInnerCircle = rOuterCircle/2
        } else {
            rInnerCircle = up/bottom
        }
        rOuterCircle = rOuterCircle - rInnerCircle

        if numberOfItems == 1 {
            rInnerCircle = rOuterCircle
            let itemFrame  = CGRect(x: 0, y: 0, width: rInnerCircle*2, height: rInnerCircle*2)
            let attributes  = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
            attributes.frame = itemFrame
            cachedCellsAttributes.append(attributes)
        } else {
        for i in 0..<Int(numberOfItems) {
            let sigmaZeta = ((360/numberOfItems) * CGFloat(i))
            let zeta: CGFloat
            let x: CGFloat
            let y: CGFloat
            switch sigmaZeta {
            case 0...90:
                zeta = sigmaZeta
                y = rOuterCircle  - rOuterCircle*sin(degrees: zeta)
                x = rOuterCircle + rOuterCircle*cos(degrees: zeta)
            case 91...180:
                zeta = 180 - sigmaZeta
                y = rOuterCircle - rOuterCircle*sin(degrees: zeta)
                x = rOuterCircle - rOuterCircle*cos(degrees: zeta)
            case 181...270:
                zeta = sigmaZeta - 180
                y = rOuterCircle + rOuterCircle*sin(degrees: zeta)
                x = rOuterCircle - rOuterCircle*cos(degrees: zeta)
            default: //271...360:
                zeta = 360 - sigmaZeta
                y = rOuterCircle*sin(degrees: zeta) + rOuterCircle
                x = rOuterCircle*cos(degrees: zeta) + rOuterCircle
            }

            let itemFrame  = CGRect(x: x, y: y, width: rInnerCircle*2, height: rInnerCircle*2)
            let attributes  = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.frame = itemFrame
            cachedCellsAttributes.append(attributes)
            }
        }

    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var layoutAttributes = [UICollectionViewLayoutAttributes]()
//        for attributes in cachedAttributes {
//            if attributes.frame.intersects(rect) {
//                layoutAttributes.append(attributes)
//            }
//        }
        return cachedCellsAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedCellsAttributes[indexPath.item]
    }

}

func sin(degrees: Double) -> Double {
    return __sinpi(degrees/180.0)
}

func sin(degrees: CGFloat) -> CGFloat {
    return CGFloat(sin(degrees: degrees.native))
}

func cos(degrees: Double) -> Double {
    return __cospi(degrees/180.0)
}

func cos(degrees: CGFloat) -> CGFloat {
    return CGFloat(cos(degrees: degrees.native))
}

//
//  TwitterHeaderLayout.swift
//  MSZ-TwitterLayout
//
//  Created by MSZ on 11/10/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import UIKit
extension PuppiesVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func registerPuppiesCollectionViewCells()  {
        let puppyCell = UINib(nibName: "PuppyCell", bundle: nil)
        puppiesCollectionView.register(puppyCell, forCellWithReuseIdentifier: PuppyCell.className)
        let userInfoCell = UINib(nibName: "UserInfoCell", bundle: nil)
        puppiesCollectionView.register(userInfoCell, forCellWithReuseIdentifier: UserInfoCell.className)

        let collectionHeaderView = UINib(nibName: "CollectionHeaderView", bundle: nil)

        puppiesCollectionView.register(collectionHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.className)
    }
    func confgPuppiesCollectionViewLayout() {
        let layout = TwitterHeaderLayout()
        puppiesCollectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.className, for: indexPath) as! CollectionHeaderView
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.inset(by: (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset).size.width
        if indexPath.row == 0 {
            return  CGSize.init(width: availableWidth, height: 0+40+8+20+16)}
        if indexPath.row == 1 {
            return  CGSize.init(width: availableWidth-2, height: (availableWidth*798/746)-2)
        }
        return  CGSize.init(width: availableWidth-2, height: (availableWidth*781/750)-2)
    }
}

class TwitterHeaderLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        guard let collectionView  = collectionView else { return }
        self.minimumLineSpacing = 2
        self.minimumInteritemSpacing = 1
        self.sectionInset = UIEdgeInsets.init(top: self.minimumLineSpacing, left: 0, bottom: 0, right: 0)
        self.sectionInsetReference = .fromContentInset
        let availableWidth = collectionView.bounds.inset(by: sectionInset).size.width
        self.itemSize = CGSize.init(width: availableWidth, height: 40)
        minimumLineSpacing = 2
        headerReferenceSize = CGSize.init(width: availableWidth, height: availableWidth/3)
    }
    
    
    override class var layoutAttributesClass : AnyClass {
        return StretchyHeaderAttributes.self
    }

    var cashedAttributesForSupplementaryViews :StretchyHeaderAttributes!


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)! as! [StretchyHeaderAttributes]

        let contentOffset = collectionView!.contentOffset

        if  layoutAttributes.first(where: {$0.representedElementKind == UICollectionView.elementKindSectionHeader}) == nil {
            let headerAttributes =  layoutAttributesForSupplementaryView(ofKind: CollectionHeaderView.className, at: IndexPath(item: 0, section: 0))
            layoutAttributes.append(headerAttributes as! StretchyHeaderAttributes)
        }

        for attributes in layoutAttributes {
            attributes.zIndex = 3
            let deltaY = abs(contentOffset.y)
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                attributes.zIndex = 1
                
                if (contentOffset.y <= 0) {
                    var frame = attributes.frame
                    frame.size.height = headerReferenceSize.height + deltaY
                    frame.origin.y = frame.minY - deltaY
                    attributes.deltaY = deltaY
                    attributes.frame = frame
                } else  if  deltaY <= headerReferenceSize.height - topBarHeight    { ///pro  max = 138.0 - 88.0 = 50 (1..50)
                    attributes.deltaYForNavBar = deltaY
                } else {
                    var frame = attributes.frame
                    frame.origin.y = contentOffset.y - (headerReferenceSize.height-topBarHeight)
                    attributes.deltaYForNavBar = headerReferenceSize.height - topBarHeight
                    attributes.frame = frame
                    attributes.zIndex = .max
                }
                // reminder space contentOffset.y + topBarHeight header and headerheight
                attributes.deltaYContentOffsetToHeaderHeight = (contentOffset.y + topBarHeight - headerReferenceSize.height)
                cashedAttributesForSupplementaryViews = attributes
                
            }
            
            if attributes.representedElementCategory == .cell {
                if attributes.indexPath.row == 0 {
                    if contentOffset.y >= 0 &&  deltaY <= headerReferenceSize.height - topBarHeight {
                        attributes.deltaYForNavBar = headerReferenceSize.height - topBarHeight - contentOffset.y
                        // reminder space between header and topBarHeight
                        attributes.deltaY = headerReferenceSize.height - topBarHeight
                    } else if contentOffset.y < 0  {
                        attributes.deltaYForNavBar = headerReferenceSize.height - topBarHeight
                        // reminder space between header and topBarHeight
                        attributes.deltaY = headerReferenceSize.height - topBarHeight
                    }
                }
            }
        }
        return layoutAttributes
    }
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cashedAttributesForSupplementaryViews
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}


//
//  CollectionHeaderView.swift
//  MSZ-TwitterLayout
//
//  Created by MSZ on 11/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var nameView: UIView!

    @IBOutlet weak var backgroundImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var navbarTopspaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameViewTopConstraint: NSLayoutConstraint!

    var visualEffectView =  UIVisualEffectView(effect: nil)
    let animator = UIViewPropertyAnimator(duration: 0.8, curve: .linear)

    var backgroundImageHeight: CGFloat = 0
    var backgroundImagewidth: CGFloat = 0
    
    var previousNavbarTopspace: CGFloat = 0
    var previousHeight: CGFloat = 0
    var previousNameLabelTop: CGFloat = 0
    


    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageHeight = UIScreen.main.bounds.width/3
        backgroundImagewidth = UIScreen.main.bounds.width
        backgroundImageHeightConstraint.constant = backgroundImageHeight
        backgroundImageWidthConstraint.constant = backgroundImagewidth
        navbarTopspaceConstraint.constant = 0

        setupVisualEffectView()

        self.bringSubviewToFront(nameView)
        self.bringSubviewToFront(navBarView)
    }

    fileprivate func setupVisualEffectView() {
        self.addSubview(visualEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true


        animator.addAnimations {
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
        }
        animator.fractionComplete = 0
    }


    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attributes = layoutAttributes as! StretchyHeaderAttributes

        if previousHeight != attributes.deltaY {

            backgroundImageHeightConstraint.constant = backgroundImageHeight + attributes.deltaY
            backgroundImageWidthConstraint.constant = backgroundImagewidth + (attributes.deltaY*3)
            previousHeight = attributes.deltaY
            animator.fractionComplete = min(1,attributes.deltaY/40)
            
        } else if previousNavbarTopspace == attributes.deltaYForNavBar {
           // ana b mins 40 case navbar = 40 attributes.deltaYContentOffsetToHeaderHeight-40)
            animator.fractionComplete = min(1, max(0,attributes.deltaYContentOffsetToHeaderHeight-40)/44 )
            // 40 for nav bar 0.1 for every 2 piont

            // -40-10 cell size image  + top
            var nameLabelTop:CGFloat = -max(0,attributes.deltaYContentOffsetToHeaderHeight-40-10) + 2 //2 top boto3 el view assan
            nameLabelTop = max(-42,nameLabelTop)
            if previousNameLabelTop != nameLabelTop {
                nameViewTopConstraint.constant = nameLabelTop
                previousNameLabelTop = nameLabelTop
            }
        }
        
        if previousNavbarTopspace != attributes.deltaYForNavBar { // attributes.deltaYForNavBar  change only between 0...50
            navbarTopspaceConstraint.constant = attributes.deltaYForNavBar 
            previousNavbarTopspace = attributes.deltaYForNavBar
            
        }
    }
}


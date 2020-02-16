//
//  PuppiesVC.swift
//  MSZ-TwitterLayout
//
//  Created by MSZ on 11/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import UIKit

class PuppiesVC: UIViewController {
    @IBOutlet weak var puppiesCollectionView: UICollectionView!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerPuppiesCollectionViewCells()
        confgPuppiesCollectionViewLayout()
        puppiesCollectionView.delegate = self
        puppiesCollectionView.dataSource = self
        puppiesCollectionView.contentInsetAdjustmentBehavior = .never
    }
    
    @IBAction func next(slider:UISlider){
        print(slider.value )
        view.viewWithTag(22)?.alpha = CGFloat(slider.value)    }
    
}


// MARK: UICollectionViewDataSource
extension PuppiesVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            return  collectionView.dequeueReusableCell(withReuseIdentifier: "UserInfoCell", for: indexPath) as! UserInfoCell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuppyCell", for: indexPath) as! PuppyCell

        // Configure the cell
        cell.config(with: indexPath.item*11)
        return cell
    }
}



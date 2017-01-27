//
//  ShopViewController.swift
//  Ping
//
//  Created by infuntis on 23/01/17.
//  Copyright © 2017 gala. All rights reserved.
//

import Foundation
import UIKit

protocol themeChangedDelegate: class {
    func themeChanged()
}

class ShopCollectionViewController: UICollectionViewController{
    let reuseIdentifier = "cell"
    
     var themeChanged :themeChangedDelegate?
   
    
    
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ThemeAnimal.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(ShopCollectionViewController.back))
    }
    
    func back() {
        themeChanged?.themeChanged()
        self.dismiss(animated: true, completion: nil);
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ShopCollectionViewCell
        if let value = ThemeAnimal(rawValue: indexPath.item) {
            cell.pet.image = UIImage(named: "\(value.string)_face_for_shop")
            cell.label.text = value.string
        }
       
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.red
    }
    
    // change background color back when user releases touch
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.cyan
        UserDefaults.standard.setValue(indexPath.item, forKey: SelectedThemeKey)
    }
    
    
    
}


extension UINavigationBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60.0)
    }
 
    
}

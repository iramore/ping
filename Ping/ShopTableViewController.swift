//
//  ShopTableViewController.swift
//  Ping
//
//  Created by infuntis on 14/06/17.
//  Copyright © 2017 gala. All rights reserved.
//

import Foundation
import UIKit

protocol themeChangedDelegate: class {
    func themeChanged()
}

class ShopTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    var themeChanged :themeChangedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 5
        tableView.dataSource = self
        tableView.delegate = self
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        themeChanged?.themeChanged()
        self.dismiss(animated: true, completion: nil)
    }
   
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        themeChanged?.themeChanged()
        return ThemeAnimal.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ShopCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShopTableViewControllerCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        if let value = ThemeAnimal(rawValue: indexPath.item) {
            cell.shopImage.image = UIImage(named: "\(value.string)_face_for_shop")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        UserDefaults.standard.setValue(indexPath.row, forKey: SelectedThemeKey)
    }
}

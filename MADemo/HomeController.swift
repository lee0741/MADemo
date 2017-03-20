//
//  ViewController.swift
//  MADemo
//
//  Created by Yancen Li on 3/16/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class HomeController: UITableViewController {
    
    let cellId = "homeCell"
    let menuItems = ["Person A", "Person B", "Person C", "Person D",
                     "Person E", "Person F", "Person G", "Person H",
                     "Person I", "Person J", "Person K", "Person L",
                     "Person M", "Person N", "Person O", "Person P",
                     "Person Q", "Person R", "Person S", "Person T",
                     "Person U", "Person V", "Person W", "Person X",
                     "Person Y", "Person Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demo"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = DetailController()
        detailController.personName = menuItems[indexPath.row]
        present(detailController, animated: true)
    }

}


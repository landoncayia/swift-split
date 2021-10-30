//
//  SettingsViewController.swift
//  SwiftSplit
//
//  Created by user204492 on 10/15/21.
//

import UIKit

class SettingsCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
}

class SettingsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var settingsTable: UITableView! {
        didSet {
            settingsTable.delegate = self;
            settingsTable.dataSource = self;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTable.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        cell.nameLabel.text = "Setting"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

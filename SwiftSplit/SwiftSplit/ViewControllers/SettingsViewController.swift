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

class SettingsViewController : UITableViewController {
    
    @IBOutlet var settingsTable: UITableView! {
        didSet {
            settingsTable.delegate = self;
            settingsTable.dataSource = self;
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTable.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        cell.nameLabel.text = "Setting"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showSetting":
            // Figure out which setting was selected
            if let settingsCell = tableView.indexPathForSelectedRow?.row {
                
                // Get the setting item associated with this cell and pass it along
//                let settingsItem = settingStore.allSettings[row]
//                let settingsItemViewController = segue.destination as! SettingsItemViewController
//                settingsItemViewController.settingItem = settingsItem
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

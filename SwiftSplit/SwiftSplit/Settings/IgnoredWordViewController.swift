//
//  SettingsViewController.swift
//  SwiftSplit
//
//  Created by user204492 on 10/15/21.
//

import UIKit

class IgnoredWordViewController: UITableViewController {
    
    var ignoredWordsList: [String]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    @IBAction func addNewIgnoredWord(_ sender: UIBarButtonItem) {
//        // Use this to add a new custom word
//        let newWords: [String] = ["Apple", "Orange", "Banana", "Lime", "Blueberry", "Grapes"]
//        customWordsList.append(newWords[0])
//        customWordsList.append(newWords[1])
//        
//        // Use an alert controller to allow the user to type the word
//        
//        if let index = customWordsList.firstIndex(of: newWords[0]) {
//            let indexPath = IndexPath(row: index, section: 0)
//            tableView.insertRows(at: [indexPath], with: .automatic)
//        }
//        if let index = customWordsList.firstIndex(of: newWords[1]) {
//            let indexPath = IndexPath(row: index, section: 0)
//            tableView.insertRows(at: [indexPath], with: .automatic)
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ignoredWordsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IgnoredWordCell", for: indexPath) as! IgnoredWordCell
        
        let ignoredWord = ignoredWordsList[indexPath.row]
        
        cell.ignoredWord.text = ignoredWord
        
        return cell
    }
    
//    @IBOutlet var settingsTable: UITableView! {
//        didSet {
//            settingsTable.delegate = self;
//            settingsTable.dataSource = self;
//        }
//    }
    
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
}

//
//  SettingsViewController.swift
//  SwiftSplit
//
//  Created by Landon Cayia on 11/11/21.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var settingsStore = SettingsStore()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showCustomWords":
            let customWordsViewController = segue.destination as! CustomWordViewController
            customWordsViewController.customWordsList = settingsStore.currentSettings.customWords
        case "showIgnoredWords":
            let ignoredWordsViewController = segue.destination as! IgnoredWordViewController
            ignoredWordsViewController.ignoredWordsList = settingsStore.currentSettings.ignoredWords
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

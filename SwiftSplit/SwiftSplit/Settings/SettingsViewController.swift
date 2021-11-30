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
        
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func toggleRecognitionLevel(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            settingsStore.currentSettings.recognitionLevel = .accurate
        case 1:
            settingsStore.currentSettings.recognitionLevel = .fast
        default:
            break
        }
    }
    
    @IBAction func toggleLanguageCorrection(_ sender: UISwitch!) {
        if sender.isOn {
            settingsStore.currentSettings.languageCorrection = true
        } else {
            settingsStore.currentSettings.languageCorrection = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showCustomWords":
            let customWordsViewController = segue.destination as! WordViewController
            customWordsViewController.wordsList = settingsStore.currentSettings.customWords
            customWordsViewController.callback = { result in
                self.settingsStore.currentSettings.customWords = result
            }
        case "showIgnoredWords":
            let ignoredWordsViewController = segue.destination as! WordViewController
            ignoredWordsViewController.wordsList = settingsStore.currentSettings.ignoredWords
            ignoredWordsViewController.callback = { result in
                self.settingsStore.currentSettings.ignoredWords = result
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

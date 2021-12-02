//
//  SettingsViewController.swift
//  SwiftSplit
//
//  Created by Landon Cayia on 11/11/21.
//

import UIKit

enum WordType: Codable {
    case IgnoredWord, CustomWord
}

class SettingsViewController: UITableViewController {
    
//    var settingsStore = SettingsStore()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.contentInset = UIEdgeInsets(top: -65, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func toggleRecognitionLevel(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            globalSettings.currentSettings.recognitionLevel = .accurate
        case 1:
            globalSettings.currentSettings.recognitionLevel = .fast
        default:
            break
        }
    }
    
    @IBAction func toggleLanguageCorrection(_ sender: UISwitch!) {
        if sender.isOn {
            globalSettings.currentSettings.languageCorrection = true
        } else {
            globalSettings.currentSettings.languageCorrection = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showCustomWords":
            let customWordsViewController = segue.destination as! WordViewController
            customWordsViewController.wordType = WordType.CustomWord
            customWordsViewController.wordsList = globalSettings.currentSettings.customWords
            customWordsViewController.callback = { result in
                globalSettings.currentSettings.customWords = result
            }
        case "showIgnoredWords":
            let ignoredWordsViewController = segue.destination as! WordViewController
            ignoredWordsViewController.wordType = WordType.IgnoredWord
            ignoredWordsViewController.wordsList = globalSettings.currentSettings.ignoredWords
            ignoredWordsViewController.callback = { result in
                globalSettings.currentSettings.ignoredWords = result
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

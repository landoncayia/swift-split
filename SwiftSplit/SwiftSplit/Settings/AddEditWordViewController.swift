//
//  SettingsViewController.swift
//  SwiftSplit
//
//  Created by user204492 on 10/15/21.
//

import UIKit

class AddEditWordViewController: UIViewController, UITextFieldDelegate {
    
    var wordsList: [String]!
    var currentWord: String?
    var callback: ((String)->())?
    @IBOutlet var wordField: UITextField!
    
//    @IBAction func addNewWord(_ sender: UIBarButtonItem) {
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
        
        wordField.text = currentWord ?? ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to pokemon
        if let wordEdit = wordField.text {
            if wordEdit != "" {
                currentWord = wordEdit
            } else {
                currentWord = "Word"
            }
            if let returnWord = currentWord {
                callback?(returnWord)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

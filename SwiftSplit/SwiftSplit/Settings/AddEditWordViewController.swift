//
//  SettingsViewController.swift
//  SwiftSplit
//
//  Created by user204492 on 10/15/21.
//

import UIKit

class AddEditWordViewController: UIViewController, UITextFieldDelegate {
    
    var currentWord: String?
    var callback: ((String)->())?
    var wordType: WordType!
    @IBOutlet var wordField: UITextField!
    @IBOutlet weak var settingDescription: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        wordField.text = currentWord ?? ""
        switch wordType {
        case .IgnoredWord:
            settingDescription.text = "Ignored words are a means to have a set of terms that SwiftSplit will ignore in its processing. This is useful for parts of receipts that are not meaningful in context of app usage."
        case .CustomWord:
            settingDescription.text = "Custom words are strings that supplement the recognized languages at the word-recognition stage. They help SwiftSplit to recognize terms found commonly on your receipts."
        default:
            settingDescription.text = "Setting description"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to word field
        if let wordEdit = wordField.text {
            if wordEdit != "" {
                currentWord = wordEdit
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

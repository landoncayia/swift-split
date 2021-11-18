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
    @IBOutlet var word: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
        
        word.text = currentWord!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

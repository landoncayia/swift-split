//
//  SettingsViewController.swift
//  SwiftSplit
//
//  Created by user204492 on 10/15/21.
//

import UIKit

class WordViewController: UITableViewController {
    
    var wordsList: [String]!
    
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
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordCell
        
        let word = wordsList[indexPath.row]
        
        cell.word.text = word
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addWord":
            // In this case, we do not need an existing word
            let addWordViewController = segue.destination as! AddEditWordViewController
            addWordViewController.callback = { result in
                self.wordsList.append(result)
                if let index = self.wordsList.firstIndex(of: result) {
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        case "editWord":
            let editWordViewController = segue.destination as! AddEditWordViewController
            editWordViewController.callback = { result in
                if let row = self.tableView.indexPathForSelectedRow?.row {
                    self.wordsList[row] = result
                }
            }
            // In this case, we need the currently-stored word
            if let row = tableView.indexPathForSelectedRow?.row {
                let word = wordsList[row]
                editWordViewController.currentWord = word
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

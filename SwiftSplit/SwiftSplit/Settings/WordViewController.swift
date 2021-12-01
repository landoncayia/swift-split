//
//  SettingsViewController.swift
//  SwiftSplit
//
//  Created by user204492 on 10/15/21.
//

import UIKit
import simd

class WordViewController: UITableViewController, UISearchBarDelegate {
    
    var wordsList: [String]!
    var filteredWords: [String]!  // Used for search
    var wordType: WordType!
    var callback: (([String])->())?
    @IBOutlet weak var wordSearchBar: UISearchBar!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWord))
        
        navigationItem.rightBarButtonItems = [editButtonItem, addBarButton]
    }
    
    @objc func addWord() {
        self.performSegue(withIdentifier: "addWord", sender: UIBarButtonItem())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Menu when options button tapped on Word View Controller in top-right
        
//        let handler: (_ action: UIAction) -> () = { action in
//            switch action.identifier.rawValue {
//            case "addWord":
//                // Segue to add edit word view controller (add variant)
//                self.performSegue(withIdentifier: "addWord", sender: nil)
//            case "deleteWord":
//                // Enter "editing mode", which is used to delete
//                self.tableView.setEditing(true, animated: true)
//            default:
//                break
//            }
//        }
//
//        // Options button menu items
//        let actions = [
//            UIAction(title: "Add Word",
//                     image: UIImage(systemName: "plus"),
//                     identifier: UIAction.Identifier("addWord"),
//                     handler: handler),
//            UIAction(title: "Delete Word(s)",
//                     image: UIImage(systemName: "trash"),
//                     identifier: UIAction.Identifier("deleteWord"),
//                     handler: handler)
//        ]
//
//        // Create the menu itself
//        let menu = UIMenu(title: "Options", children: actions)
//
//        // Set the bar button item to the circle ellipse icon and connect menu
//        let rightBarButton = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), menu: menu)
//        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // "Save" changes to word array
        if let newWordArr = wordsList {
            if !newWordArr.isEmpty {
                callback?(newWordArr)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordSearchBar.delegate = self
        wordSearchBar.placeholder = "Search for a word"
        wordSearchBar.enablesReturnKeyAutomatically = false
        wordSearchBar.returnKeyType = .done
        filteredWords = wordsList
        
        switch wordType {
        case .IgnoredWord:
            navigationItem.title = "Ignored Words"
        case .CustomWord:
            navigationItem.title = "Custom Words"
        default:
            navigationItem.title = "Words"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordCell
        
        let word = filteredWords[indexPath.row]
        
        cell.word.text = word
        
        return cell
    }
    
    // Allow editing/deleting of all cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Editing/deleting functionality
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // Remove element
            let wordToDelete = wordsList[indexPath.row]
            
            // Creates an Alert controller
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete \(wordToDelete)", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                print("Deleting")
                
                // Remove the Pokemon from the store
                if let removeIndex = self.wordsList.firstIndex(of: wordToDelete) {
                    self.wordsList.remove(at: removeIndex)
                }
                
                // Also remove that row from the table view with an animation
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alertController.addAction(delete)
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
                print("Canceling")
            }
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredWords = searchText.isEmpty ? wordsList : wordsList.filter { (word: String) -> Bool in
            return word.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.wordSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        wordSearchBar.showsCancelButton = false
        wordSearchBar.text = ""
        wordSearchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addWord":
            // In this case, we do not need an existing word
            let addWordViewController = segue.destination as! AddEditWordViewController
            addWordViewController.wordType = self.wordType
            addWordViewController.navigationItem.title = "Add Word"
            addWordViewController.callback = { result in
                self.wordsList.append(result)
                if let index = self.wordsList.firstIndex(of: result) {
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        case "editWord":
            let editWordViewController = segue.destination as! AddEditWordViewController
            editWordViewController.wordType = self.wordType
            editWordViewController.navigationItem.title = "Edit Word"
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

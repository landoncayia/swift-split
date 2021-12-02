//  BrowseViewController.swift
//  SwiftSplit

import UIKit

class BrowseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    var filteredReceipts: [Receipt]!
    
    @IBOutlet var searchBar: UISearchBar!
    
    
    // Nested collection view
    @IBOutlet var receiptCollection: UICollectionView!{
        didSet {
            receiptCollection.delegate = self
            receiptCollection.dataSource = self
            //receiptCollection.rowHeight = UITableView.automaticDimension
            //receiptCollection.estimatedRowHeight = 80
                        
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
        
        globalReceipts.setTags()
        
        // Clears cell selection when you come from another view
        if let indexPath = receiptCollection?.indexPathsForSelectedItems{
            if !indexPath.isEmpty {
                receiptCollection.deselectItem(at: indexPath[0], animated: true)
            }
        }
        
//        if let indexPath = receiptCollection.indexPathForSelectedRow {
//            receiptCollection.deselectRow(at: indexPath, animated: true)
//        }
        
        filteredReceipts = globalReceipts.receipts
        print("Browse WillAppear globalReceipts size: " + String(globalReceipts.receipts.count))
        print("BrowseVC WillAppear currReceipt: \(currReceipt)")
        
        receiptCollection.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Search for a receipt name"
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        filteredReceipts = globalReceipts.receipts

        navigationItem.rightBarButtonItem = editButtonItem
        //navigationItem.rightBarButtonItem?.primaryAction =
        
        print("BrowseVC loaded")
        print("BrowseVC viewDidLoad currReceipt: \(currReceipt)")
    }
 
    @IBAction func bkgdTapped(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredReceipts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = receiptCollection.dequeueReusableCell(withReuseIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell

        let receipt = filteredReceipts[indexPath.row]
            
        let cost = String(format: "%.2f", receipt.getWholeCost())
            
        item.nameLabel.text = receipt.name
        item.costLabel.text = "$\(cost)"
            
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "en_US")
        dateFormat.dateFormat = "MM/dd/yyyy"
        item.dateLabel.text = dateFormat.string(from: receipt.date)
            
        item.clipsToBounds = true
        item.layer.cornerRadius = 5
        
        return item
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            let receipt = filteredReceipts[indexPath.row]
            currReceipt = receipt.tag
            
            print("Browse receipt selected with tag \(receipt.tag)")

            // Open the existing receipt
            performSegue(withIdentifier: "openReceipt", sender: self)
    //        self.tabBarController?.selectedIndex = 1
        }
        
        
        
        
        
    }
    
    
    @IBAction func toggleEdit(_ sender: UIBarButtonItem){
        if isEditing {
            setEditing(false, animated: true)
            self.receiptCollection.isEditing = false
        } else {
            setEditing(true, animated: true)
            self.receiptCollection.isEditing = true
        }
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        

        
//        for path in receiptCollection.indexPathsForVisibleItems {
//            let item = receiptCollection.cellForItem(at: path) as! ReceiptCell
//
//
//
//
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Return num of rows in a section of the view
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredReceipts.count
//    }
    
    // Insert a cell at a location in the view
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell
//
//        let receipt = filteredReceipts[indexPath.row]
//
//        let cost = String(format: "%.2f", receipt.getWholeCost())
//
//        cell.nameLabel.text = receipt.name
//        cell.costLabel.text = "$\(cost)"
//
//
//        let dateFormat = DateFormatter()
//        dateFormat.locale = Locale(identifier: "en_US")
//
//
//        let date = Date()
//        dateFormat.dateFormat = "MM/dd/yyyy"
//        let today = dateFormat.string(from: date)
//
//        if today == dateFormat.string(from: receipt.date){
//            dateFormat.dateFormat = "hh:mm a"
//            cell.dateLabel.text = "Today @ \(dateFormat.string(from: date))"
//        } else {
//            cell.dateLabel.text = dateFormat.string(from: receipt.date)
//            //cell.dateLabel.text = dateFormat.string(from: date)
//        }
//
////        cell.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 255)
////        cell.layer.borderWidth = 1.0
////        cell.layer.cornerRadius = 8
//        cell.clipsToBounds = true
//
//        return cell
//
//    }
    
    // Segue from cell tap to receipt details in create storyboard
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let receipt = filteredReceipts[indexPath.row]
//        currReceipt = receipt.tag
//
//        print("Browse cell selected with tag \(receipt.tag)")
//
//        self.tabBarController?.selectedIndex = 1
//    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredReceipts = globalReceipts.receipts
        } else {
            filteredReceipts = globalReceipts.receipts.filter {(receipt: Receipt) -> Bool in
                return receipt.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
        
        receiptCollection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Close keyboard
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { print("Began editing") }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { print("Stopped editing") }
}

class ReceiptCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    
//    var isinEditingMode: Bool {
//        return (superview as! UICollectionView).allowsMultipleSelection
//    }
}

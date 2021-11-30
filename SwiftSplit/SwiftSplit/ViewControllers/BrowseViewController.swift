//  BrowseViewController.swift
//  SwiftSplit

import UIKit

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var filteredReceipts: [Receipt]!
    
    @IBOutlet var searchBar: UISearchBar!
    
    // Nested table view
    @IBOutlet var receiptTable: UITableView!{
        didSet {
            receiptTable.delegate = self
            receiptTable.dataSource = self
            receiptTable.rowHeight = UITableView.automaticDimension
            receiptTable.estimatedRowHeight = 80
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
        
        // Clears cell selection when you come from another view
        if let indexPath = receiptTable.indexPathForSelectedRow {
            receiptTable.deselectRow(at: indexPath, animated: true)
        }
        
        filteredReceipts = globalReceipts.receipts
        print("Browse WillAppear globalReceipts size: " + String(globalReceipts.receipts.count))
        print("BrowseVC WillAppear currReceipt: \(currReceipt)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Search for a receipt name"
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        filteredReceipts = globalReceipts.receipts
    
        print("BrowseVC loaded")
        print("BrowseVC viewDidLoad currReceipt: \(currReceipt)")
    }
 
    @IBAction func bkgdTapped(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    // Return num of rows in a section of the view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredReceipts.count
    }
    
    // Insert a cell at a location in the view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell

        let receipt = filteredReceipts[indexPath.row]
            
        let cost = String(format: "%.2f", receipt.getWholeCost())
            
        cell.nameLabel.text = receipt.name
        cell.costLabel.text = "$\(cost)"
            

        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "en_US")
            
            
        let date = Date()
        dateFormat.dateFormat = "MM/dd/yyyy"
        let today = dateFormat.string(from: date)
        
        if today == dateFormat.string(from: receipt.date){
            dateFormat.dateFormat = "hh:mm a"
            cell.dateLabel.text = "Today @ \(dateFormat.string(from: date))"
        } else {
            cell.dateLabel.text = dateFormat.string(from: receipt.date)
            //cell.dateLabel.text = dateFormat.string(from: date)
        }
            
//        cell.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 255)
//        cell.layer.borderWidth = 1.0
//        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    // Segue from cell tap to receipt details in create storyboard
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let receipt = filteredReceipts[indexPath.row]
        currReceipt = receipt.tag
        
        print("Browse cell selected with tag \(receipt.tag)")

        self.tabBarController?.selectedIndex = 1
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Code from - https://guides.codepath.com/ios/Search-Bar-Guide
        filteredReceipts = searchText.isEmpty ? globalReceipts.receipts : globalReceipts.receipts.filter { (receipt: Receipt) ->
            Bool in
            return receipt.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        receiptTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Close keyboard
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { print("Began editing") }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { print("Stopped editing") }
}

class ReceiptCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
}

//  BrowseViewController.swift
//  SwiftSplit

import UIKit

class BrowseViewController : UITableViewController {
    var receiptStore: ReceiptStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Browse view controller loaded")
    }
 
    // Return num of rows in a section of the view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // temporary
    }
    
    // Insert a cell at a location in the view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
                
        print("Browse receipt store size: \(receiptStore.receipts.count)")

        
        if let receipts = receiptStore {
            //let receipt = receipts.receipts[0]
            let receipt = receiptStore.receipts[indexPath.row]
            cell.textLabel?.text = receipt.name
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale(identifier: "en_US")
            cell.detailTextLabel?.text = dateFormat.string(from: receipt.date)
            return cell
            
        }
        return cell
    }
}




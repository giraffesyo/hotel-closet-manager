//
//  InventoryClosetsTableViewController.swift
//  T02_Blue
//
//  Created by Saptami Biswas on 11/11/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class InventoryClosetsTableViewController: UITableViewController {
    
    let ref: DatabaseReference! = Database.database().reference()
    //var closets = ["Closet 1"]
    var closets = [Closet]()
    var closetObserverIdentifier: UInt = 0
    var deleteObserverIdentifier: UInt = 0
    
    struct Closet {
        let floor: Int!
        let number: Int!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var items = [UIBarButtonItem]()
        //push all items to the right
        //items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddClosetView)))
        self.navigationItem.rightBarButtonItems = items
        //load the closets from our data source
        loadClosets()
        // Add deletion detection
        setupDeleteObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return closets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let floorNumber = closets[indexPath.row].floor!
        let closetNumber = closets[indexPath.row].number!
        let cellText = "Floor \(floorNumber) Closet \(closetNumber)"
        cell.textLabel?.text = cellText
        
        // Configure the cell...
        
        return cell
    }
    
    
    
    func loadClosets() -> Void {
        
        // create a callback that subscribes to child added events for the closets key in our database
        self.closetObserverIdentifier = ref.child("closets").queryOrderedByKey().observe(.childAdded, with: { snapshot in
            if let closet = snapshot.value as? [AnyHashable:Int]{
                // get our closet number and floor number out of the snapshot
                let closetNumber: Int = closet["closet"]!
                let floorNumber: Int = closet["floor"]!
                // add the closet to our closets collection
                self.closets.insert(Closet(floor: floorNumber, number: closetNumber), at: 0)
                // reload table view
                self.tableView.reloadData()
            }}
        )
    }
    
    
    func setupDeleteObserver() -> Void {
        self.deleteObserverIdentifier = ref.child("closets").queryOrderedByKey().observe(.childRemoved, with: {snapshot in
            // remove closet observer if it exists
            if self.closetObserverIdentifier != 0 {
                self.ref.removeObserver(withHandle: self.closetObserverIdentifier)
            }
            self.closets.removeAll()
            self.loadClosets()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //remove observers here
        ref.removeObserver(withHandle: self.deleteObserverIdentifier)
        ref.removeObserver(withHandle: self.closetObserverIdentifier)
    }
    
    @objc func navigateToAddClosetView() -> Void {
        self.performSegue(withIdentifier: "Add new closet", sender: self)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

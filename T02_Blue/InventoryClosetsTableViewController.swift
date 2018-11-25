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
    
    struct Closet {
        let floor: Int!
        let number: Int!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadClosets()
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
    /*
    @IBAction func addCloset(_ sender: UIBarButtonItem)
    {
        closets.append("Closet \(closets.count + 1)")
        //tableView.insertRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
        tableView.reloadData()
    }*/
    
    func loadClosets() -> Void {
        print("hello world")
        // create a callback that subscribes to child added events for the closets key in our database
        ref.child("closets").queryOrderedByKey().observe(.childAdded, with: { snapshot in
            if let closet = snapshot.value as? [AnyHashable:Int]{
                // get our closet number and floor number out of the snapshot
                let closetNumber: Int = closet["closet"]!
                let floorNumber: Int = closet["floor"]!
                print("floor number is \(floorNumber)")
                // add the closet to our closets collection
                self.closets.insert(Closet(floor: floorNumber, number: closetNumber), at: 0)
                // reload table view
                self.tableView.reloadData()
            }}
            )
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

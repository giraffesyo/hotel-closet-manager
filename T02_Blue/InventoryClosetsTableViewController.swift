//
//  InventoryClosetsTableViewController.swift
//  T02_Blue

import UIKit
import FirebaseDatabase

class InventoryClosetsTableViewController: UITableViewController {
    
    let ref: DatabaseReference! = Database.database().reference()
    let db = InventoryDatabase.init()
    var closets = [Closet]()
    var closetObserverIdentifier: UInt = 0
    var deleteObserverIdentifier: UInt = 0
    var selectedId: String = ""
    var Editing: Bool = false
    
    struct Closet {
        let id: String!
        let floor: Int!
        let number: Int!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup our navigation bar
        setupNavigationBar()
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closets.count
    }
    
    // Handles the transition that brings the user to the inventory screen for the tapped closet/row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //The user selected a cell, we don't do anything if we're in editing mode
        if(!self.Editing){
            self.selectedId = closets[indexPath.row].id
            performSegue(withIdentifier: "Closet Inventory Details", sender: self)
        }
    }
    
    // Puts information on each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let floorNumber = closets[indexPath.row].floor!
        let closetNumber = closets[indexPath.row].number!
        let cellText = "Floor \(floorNumber) Closet \(closetNumber)"
        
        cell.textLabel?.text = cellText
        
        // Configure the cell...
        
        return cell
    }
    
    // handles the deletion of closets from firebase when the delete button is pressed
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //get id from cell, this will be what we use to delete it from firebase since its the key name
            let id: String = closets[indexPath.row].id
            // delete the closet
            db.deleteCloset(closetId: id)
        }
    }
    
    // Loads the closets from firebase, sets up an observer which automatically updates the view whenever a new closet is added
    func loadClosets() -> Void {
        // create a callback that subscribes to child added events for the closets key in our database
        self.closetObserverIdentifier = ref.child("closets").queryOrderedByKey().observe(.childAdded, with: { snapshot in
            if let closet = snapshot.value as? [AnyHashable: Int]{
                // get our closet number and floor number out of the snapshot, snapshot key will be used as unique id
                let id: String = snapshot.key
                let closetNumber: Int = closet["closet"]!
                let floorNumber: Int = closet["floor"]!
                // add the closet to end of our closets collection
                self.closets.insert(Closet( id: id, floor: floorNumber, number: closetNumber ), at: self.closets.endIndex)
                // reload table view
                self.tableView.reloadData()
            }}
        )
    }
    
    
    func setupDeleteObserver() -> Void {
        self.deleteObserverIdentifier = ref.child("closets").queryOrderedByKey().observe(.childRemoved, with: {snapshot in
            // remove closet observer if it exists, that way its not stacked when we call load closets again
            if self.closetObserverIdentifier != 0 {
                self.ref.removeObserver(withHandle: self.closetObserverIdentifier)
            }
            // empty our closets collection so we can reload it
            self.closets.removeAll()
            self.loadClosets()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //remove observers here so we don't stack them when reentering the view
        ref.removeObserver(withHandle: self.deleteObserverIdentifier)
        ref.removeObserver(withHandle: self.closetObserverIdentifier)
    }
    
    // Toggles editing state on or off
    @objc func toggleEditMode() -> Void {
        self.Editing = !self.Editing
        // this enables the editing mode for rows that return editingstyle.delete (all rows when self.Editing is true)
        self.setEditing(self.Editing, animated: true)
        // reset navigation bar
        setupNavigationBar()
    }
    
    // Necessary for self.setEditing() method to show our editing icons
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if(self.Editing){
            return UITableViewCell.EditingStyle.delete
        } else {
            return UITableViewCell.EditingStyle.none
        }
    }
    
    // Shows the appropriate navigation bar depending if we are editing or not, called on toggle and when view loads
    func setupNavigationBar() {
        var items = [UIBarButtonItem]()
        if(self.Editing){
            // Done, when pressed brings you back out of edit mode
            items.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleEditMode)))
        } else {
            // + button, segues to the add closet view
            items.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddClosetView)))
            //  when pressed it changes view into edit mode
            items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(toggleEditMode)))
        }
        self.navigationItem.rightBarButtonItems = items
    }
    
    
    @objc func navigateToAddClosetView() -> Void {
        self.performSegue(withIdentifier: "Add new closet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Closet Inventory Details"){
            let destination = segue.destination as! ClosetInventoryTableViewController
            destination.closet = self.selectedId
        }
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

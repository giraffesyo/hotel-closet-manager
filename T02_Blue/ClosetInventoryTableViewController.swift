//
//  ClosetInventoryTableViewController.swift
//  T02_Blue


import UIKit
import FirebaseDatabase

class ClosetInventoryTableViewController: UITableViewController {
    
    var closet: String = ""
    let ref: DatabaseReference! = Database.database().reference()
    let db = InventoryDatabase.init()
    var itemObserverIdentifier: UInt = 0
    var deleteObserverIdentifier: UInt = 0
    var modifyObserverIdentifier: UInt = 0
    
    struct Item {
        var id: String {
            get {
                return closetId + name
            }
        }
        var closetId: String!
        var name: String!
        var maximumCount: Int!
        var count: Int!
    }
    
    var items: [Item] = [Item]()
    var Editing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addDeleteObserver()
        addModifyObserver()
        loadItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    // Necessary for self.setEditing() method to show our editing icons
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if(self.Editing){
            return UITableViewCell.EditingStyle.delete
        } else {
            return UITableViewCell.EditingStyle.none
        }
    }
    
    //handle deletion button clicked on a cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let id = items[indexPath.row].id
            db.deleteItem(itemId: id)
        }
    }
    
    // Toggles editing state on or off
    @objc func toggleEditMode() -> Void {
        self.Editing = !self.Editing
        // this enables the editing mode for rows that return editingstyle.delete (all rows when self.Editing is true)
        self.setEditing(self.Editing, animated: true)
        // reset navigation bar
        setupNavigationBar()
    }
    
    
    // Shows the appropriate navigation bar depending if we are editing or not, called on toggle and when view loads
    func setupNavigationBar() {
        var items = [UIBarButtonItem]()
        if(self.Editing){
            // Done, when pressed brings you back out of edit mode
            items.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleEditMode)))
        } else {
            // + button, segues to the add item view
            items.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddItemView)))
            //  when pressed it changes view into edit mode
            items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(toggleEditMode)))
        }
        self.navigationItem.rightBarButtonItems = items
    }
    
    
    @objc func navigateToAddItemView() -> Void {
        self.performSegue(withIdentifier: "Add new item", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add new item" {
            let destination = segue.destination as! AddInventoryItemViewController
            destination.closet = self.closet
        }
    }
    
    // Adds an observer which handles modification events
    func addModifyObserver() -> Void {
        self.modifyObserverIdentifier = self.ref.child("items").queryOrdered(byChild: "closetId").queryEqual(toValue: self.closet).observe(.childChanged, with: {snapshot in
            if let value = snapshot.value as? [String: Any] {
                // get item id (its the key)
                let id: String = snapshot.key
                // get new max count out of the dictionary
                let maximumCount = value["maximumCount"] as! Int
                let count = value["count"] as! Int
                //find the item in our items collection and update it
                let foundIndex: Int = self.items.index { $0.id == id }!
                self.items[foundIndex].maximumCount = maximumCount
                self.items[foundIndex].count = count
                //reload table view
                self.tableView.reloadData()
            }
        })
    }
    
    // Adds an observer which handles deletion events
    func addDeleteObserver() -> Void {
        self.deleteObserverIdentifier = self.ref.child("items").queryOrdered(byChild: "closetId").queryEqual(toValue: self.closet).observe(.childRemoved, with: {snapshot in
            // remove the items from the list and then reload items
            self.items.removeAll()
            self.loadItems()
        })
    }
    
    
    // Loads the items from firebase, sets up an observer which automatically updates the view whenever a new item is added
    func loadItems() -> Void {

        //if we already registered an observer, unregister it
        if itemObserverIdentifier != 0 {
            self.ref.removeObserver(withHandle: itemObserverIdentifier)
        }
        //todo: rewrite using the logic found at https://firebase.google.com/docs/database/ios/lists-of-data
        // current issue is that we're recreating entire list each time an event is observed
        // we can optimize this by only updating the data that changes
        // create a callback that subscribes to child added events for the items key in this closet
        self.itemObserverIdentifier = self.ref.child("items").queryOrdered(byChild: "closetId").queryEqual(toValue: self.closet).observe(.childAdded, with: {snapshot in
            
            if let value = snapshot.value as? [String: Any] {
                // get all values out of the dictionary
                let closetId = value["closetId"] as! String
                let name = value["name"] as! String
                let maximumCount = value["maximumCount"] as! Int
                let count = value["count"] as! Int
                // create our struct from the values we obtained
                let item = Item(closetId: closetId, name: name, maximumCount: maximumCount, count: count)
                // insert our item into the end of our items collection
                self.items.insert(item, at: self.items.endIndex)
                //reload table view
                
                self.tableView.reloadData()
            }
            
        })
    }
    
    // this is the swipe controls for edit and delete
    /*
     override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
     let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {_,indexPath in
     print("editing"
     )})
     let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {_,indexPath in
     print("deleting"
     )})
     return [deleteAction, editAction]
     }*/
    
    // when the "i" is pressed this event happens
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let selectedItem = items[indexPath.row].id
        let selectedItemName = items[indexPath.row].name
        let selectedItemCount = items[indexPath.row].count
        
        
        // create alert
        let alert = UIAlertController(title: "Edit Maximum Quantity", message: "Enter new maximum quantity\nMust fit currrent stock: \(selectedItemCount!)", preferredStyle: .alert)
        //create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) in
            guard let textField = alert.textFields?.first else {
                return
            }
            guard let newMaximumCount: Int = Int(textField.text!) else {
                //they entered a string
                return
            }
            
            self.db.updateItemDetails(itemId: selectedItem, name: selectedItemName!, maximumCount: newMaximumCount)
        })
        // disable save until input is valid
        saveAction.isEnabled = false
        //add text field
        alert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter a new maximum"
            textfield.keyboardType = .numberPad
            // register changes to the text field to make sure that it is always a valid input, if it isnt, keep the save button disabled
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textfield, queue: OperationQueue.main, using: {(notification) in
                guard let valueEntered = Int(textfield.text!) else {
                    saveAction.isEnabled = false
                    return
                }
                saveAction.isEnabled = valueEntered >= selectedItemCount!})
        })
        // present the alert
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Event called when a row is tapped, used for making the alert that allows quantity change
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //The user selected a cell, we don't do anything if we're in editing mode
        if(!self.Editing){
            let selectedItem = items[indexPath.row].id
            let selectedItemName = items[indexPath.row].name
            let selectedItemMaximumCount = items[indexPath.row].maximumCount
            // create alert
            let alert = UIAlertController(title: "Edit Quantity", message: "Enter current count. \nMust be less than \(self.items[indexPath.row].maximumCount!)", preferredStyle: .alert)
            //create actions
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) in
                guard let textField = alert.textFields?.first else {
                    return
                }
                guard let newCount: Int = Int(textField.text!) else {
                    //they entered a string
                    return
                }
                self.db.updateItemCount(itemId: selectedItem, count: newCount)
            })
            //add text field
            alert.addTextField(configurationHandler: {textfield in
                textfield.placeholder = "Enter new count for: \(selectedItemName!)"
                textfield.keyboardType = .numberPad
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textfield, queue: OperationQueue.main, using: {(notification) in
                    guard let valueEntered = Int(textfield.text!) else {
                        saveAction.isEnabled = false
                        return
                    }
                    saveAction.isEnabled = valueEntered <= selectedItemMaximumCount!
                })
            })
            //process the input
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item cell", for: indexPath)
        let item: Item! = items[indexPath.row]
        let cellText = "\(item.name!)"
        let cellSubText = "\(item.count!)/\(item.maximumCount!)"
        cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        cell.textLabel?.text = cellText
        cell.detailTextLabel?.text = cellSubText
        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // clean up our observers when we leave the view
        self.ref.removeObserver(withHandle: itemObserverIdentifier)
        self.ref.removeObserver(withHandle: deleteObserverIdentifier)
        self.ref.removeObserver(withHandle: modifyObserverIdentifier)
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

//
//  UserManagementController.swift
//  T02_Blue
//
//  Created by joshua mcmahan on 11/27/18.
//  Copyright © 2018 Team Blue. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserManagementController: UITableViewController {

    struct User: Equatable {
        static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
        }
        let uid: String
        let email: String
    }
    var users = [User]()
    
    var usersRef: DatabaseReference! = Database.database().reference().child("/users")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationControls()
        setupObservers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "to edit user", sender: self)
    }
    
    func navigationControls() {
        var items = [UIBarButtonItem]()
        
        // + button, segues to the add closet view
        items.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToUserCreation)))
        self.navigationItem.rightBarButtonItems = items
    }

    @objc func goToUserCreation() -> Void {
        performSegue(withIdentifier: "to user creation", sender: self)
    }
    
    func setupObservers() -> Void {
        // Listen for new users in the Firebase database
        usersRef.observe(.childAdded, with: { (snapshot) -> Void in
            let uid = snapshot.key
            let value = snapshot.value as! [String: AnyObject]
            let email = value["email"] as! String
            let user = User(uid: uid, email: email)
            self.users.append(user)
            self.tableView.insertRows(at: [IndexPath(row: self.users.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
        })
        // Listen for deleted users in the Firebase database
        usersRef.observe(.childRemoved, with: { (snapshot) -> Void in
            let uid = snapshot.key
            let value = snapshot.value as! [String: AnyObject]
            let email = value["email"] as! String
            let user = User(uid: uid, email: email)
            
            let index = self.users.index(of: user)!
            self.users.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.automatic)
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
        // set email to the label
        cell.textLabel?.text = users[indexPath.row].email
        

        return cell
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

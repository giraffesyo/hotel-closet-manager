//
//  InventoryDatabase.swift
//  T02_Blue
//
//  Created by Michael McQuade on 11/25/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class InventoryDatabase: NSObject {
    var ref: DatabaseReference! = Database.database().reference()
    
    //Returns true if successfully created the closet
    func createCloset(closetNumber: Int, floorNumber: Int) -> Void {
        // create unique closet id by using floor number and closet number as uid
        let closetId: String = "F" + String(floorNumber) + "C" + String(closetNumber)
        self.ref.child("closets").child(closetId).setValue(["closet": closetNumber, "floor": floorNumber])}

    // Creates an item given parameters of closet ID, name, and Max Count (threshold)
    func createItem(closetId: String, name: String, maximumCount: Int) -> Void {
        // create unique item id by concatenating item name and closet id
        let itemId: String = closetId + name
        // Create our item, initial count will always be zero.
        self.ref.child("items").child(itemId).setValue(["closetId": closetId, "name": name, "count": 0, "maximumCount": maximumCount])
    }
    
    // Retrieves view ref for a given closet
    /*func retrieveItems(closetId: String) -> DatabaseQuery {
        let view: DatabaseQuery = self.ref.child("items").queryOrderedByKey().queryEqual(toValue: closetId, childKey: "closetId")
        view.
    }*/
    
    
    //Update the details of an item
    func updateItemDetails(itemId: String, name: String, maximumCount: Int) -> Void {
        self.ref.child("items/\(itemId)/name").setValue(name)
        self.ref.child("items/\(itemId)/maximumCount").setValue(maximumCount)
        }
    
    //Update an items inventory count
    func updateItemCount(itemId: String, count: Int) -> Void {
        self.ref.child("items/\(itemId)/count").setValue(count)
    }
    
    // Delete an item
    func deleteItem(itemId: String) -> Void {
        self.ref.child("items/\(itemId)").removeValue()
    }
    
    //Delete a closet
    func deleteCloset(closetId: String) -> Void {
        // first delete all items in the closet
        self.ref.child("items").queryOrderedByKey().queryEqual(toValue: closetId, childKey: "closetId").ref.removeValue()
        self.ref.child("closets/\(closetId)").removeValue()
    }
    
}

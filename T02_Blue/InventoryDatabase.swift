//
//  InventoryDatabase.swift
//  T02_Blue


import UIKit
import FirebaseDatabase
import Alamofire

class InventoryDatabase: NSObject {
    let psk: String = "Xh$N56@0,QD(N(34H6H;tpLk+~gT]R/H}y}KkP=;|r}ttOmsu7ZVl[]doHjr[{zCL,SRz)HdFUS.Dj$u"
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
        self.ref.child("items").queryOrdered(byChild: "closetId").queryEqual(toValue: closetId).observe(.value, with: {snapshot in
            if let items = snapshot.value as? [String: [String: AnyObject]] {
                for(key, _ ) in items {
                    self.ref.child("items").child(key).removeValue()
                }
            }
        })
        // then delete the closet itself
        self.ref.child("closets/\(closetId)").removeValue()
    }
    
    /*
     struct AdminResponse {
     let result: String
     let success: Bool
     }*/
    
    
    func checkIfAdmin(uid: String, completion: @escaping ( _ isAdmin: Bool) -> Void) -> Void {
        self.ref.child("users/\(uid)/admin").observeSingleEvent(of: .value, with: {(snapshot) in
            let isAdmin = snapshot.value as! Bool
            completion(isAdmin)
            
        })
    }
    
    func updateUser(uid: String, admin: Bool, completion: @escaping () -> Void) -> Void {
        
        self.ref.child("/users/\(uid)/admin").setValue(admin)
        completion()
    }
    
    func updateUser(uid: String, password: String, admin: Bool, completion: @escaping ( _ success: [String: AnyObject]) -> Void) -> Void {
        self.ref.child("/users/\(uid)/admin").setValue(admin)
        let urlString = "https://us-central1-hotel-management-5d4ed.cloudfunctions.net/updateUser"
        
        let parameters: Parameters = ["uid": uid, "password": password, "psk": psk]
        
        //create the request
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! [String: AnyObject]
                    completion(JSON)
                }
            case .failure ( let error):
                // our api shouldnt return errors in this manner so we shouldnt reach this
                print("reached .failure")
                print(error)
            }
            
        })
    }
    
    func VerifyUserAgainstDb(uid: String, email: String) -> Void {
        // we need to ensure that this user is in the database
        // the only way a user would not be in the database is if it was made directly
        // within firebase, as the in-app creation of users ensures their entry
        // into the database
        self.ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            if(snapshot.childrenCount == 0 ){
                //make them an admin
                snapshot.ref.child(uid).updateChildValues(["email": email, "admin": true])
            } else if !snapshot.hasChild(uid) {
                snapshot.ref.child(uid).updateChildValues(["email": email, "admin": false])
            }
            
        })
        
    }
    
    func createAccount(email username: String, password: String, isAdmin: Bool, completion: @escaping ( _ success: [String: AnyObject]) -> Void) -> Void {
        let urlString = "https://us-central1-hotel-management-5d4ed.cloudfunctions.net/createUser"
        //let urlString = "http://localhost:5000/hotel-management-5d4ed/us-central1/createUser"
        // create parameters to be used as http body
        let parameters: Parameters = ["email": username, "password": password, "psk": psk]
        //create the request
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! [String: AnyObject]
                    let success = JSON["success"] as! Bool
                    
                    if(success) {
                        let uid = JSON["result"]
                        let user: Parameters = ["email": username, "admin": isAdmin]
                        self.ref.child("/users/\(uid!)").updateChildValues(user) {
                            error, ref in
                            completion(JSON)
                        }
                    }
                }
            case .failure ( let error):
                // our api shouldnt return errors in this manner so we shouldnt reach this
                print("reached .failure")
                print(error)
            }
            
        })
    }
    
}

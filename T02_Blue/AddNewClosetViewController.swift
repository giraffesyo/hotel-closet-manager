//
//  AddNewClosetViewController.swift
//  T02_Blue


import UIKit
import FirebaseDatabase

class AddNewClosetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfClosetNumber: UITextField!
    @IBOutlet weak var tfFloorNumber: UITextField!
    
    let db = InventoryDatabase.init()
    let ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfClosetNumber.delegate = self
        self.tfFloorNumber.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func SavePressed(_ sender: UIButton) {
        let closetNumber: Int? = Int(tfClosetNumber.text!)
        let floorNumber: Int? = Int(tfFloorNumber.text!)
        if ( closetNumber == nil || floorNumber == nil ){
            // the user entered non numeric data somehow
            // TODO: put a message saying invalid numbers
            // TODO: change this to a guard let
            return
        }
        let closetId = "F\(floorNumber!)C\(closetNumber!)"
        
        // first, ensure that item doesn't already exist
        self.ref.child("closets").child(closetId).observeSingleEvent(of: .value, with: {snapshot in
            // we don't want to do anything if this snapshot exists, so we'll return false to let the user know it already exists
            if snapshot.exists() {
                let alert = UIAlertController(title: "Duplicate Item", message: "Closet \(closetNumber!) already exists on this floor.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                // Add the closet to the database
                self.db.createCloset(closetNumber: closetNumber!, floorNumber: floorNumber!)
                // Transition back to the closets screen
                self.navigationController?.popViewController(animated: false)
            }})
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  AddInventoryItemViewController.swift
//  T02_Blue


import UIKit
import FirebaseDatabase


class AddInventoryItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfThresholdAmount: UITextField!
    let db = InventoryDatabase.init()
    let ref: DatabaseReference! = Database.database().reference()
    var closet: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfName.delegate = self
        self.tfThresholdAmount.delegate = self
        addDoneButtonOnKeyboard()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if nextResponder != nil {
            // Give control to the next text field
            nextResponder?.becomeFirstResponder()
        } else {
            // close keypad
            
            textField.resignFirstResponder()
        }
        return false
    }
    
    // add a done button right above numeric keypad
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.tfThresholdAmount.inputAccessoryView = doneToolbar
    }
    // done button should close the keypad
    @objc func doneButtonAction()
    {
        self.tfThresholdAmount.resignFirstResponder()
    }
    
    @IBAction func SavePressed(_ sender: UIButton) {
        let itemName: String = tfName.text!
        let maximumCount: Int? = Int(tfThresholdAmount.text!)
        let itemId: String = closet+itemName
        if (itemName == "" || maximumCount == nil ){
            // the user entered bad/non numeric data somehow
            // TODO: put a message saying invalid numbers
            // TODO: change this to a guard let
            return
        }
        // first, ensure that item doesn't already exist
        self.ref.child("items").child(itemId).observeSingleEvent(of: .value, with: {snapshot in
            // we don't want to do anything if this snapshot exists, so we'll return false to let the user know it already exists
            if snapshot.exists() {
                let alert = UIAlertController(title: "Duplicate Item", message: "An item with the name \(itemName) already exists in this closet.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                // Add the closet to the database
                self.db.createItem(closetId: self.closet, name: itemName, maximumCount: maximumCount!)
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

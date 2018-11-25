//
//  AddNewClosetViewController.swift
//  T02_Blue
//
//  Created by Saptami Biswas on 11/14/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

import UIKit

class AddNewClosetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfClosetNumber: UITextField!
    @IBOutlet weak var tfFloorNumber: UITextField!
    
    let db = InventoryDatabase.init()
    
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
        // Add the closet to the database
        db.createCloset(closetNumber: closetNumber!, floorNumber: floorNumber!)
        // Transition back to the closets screen
        
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

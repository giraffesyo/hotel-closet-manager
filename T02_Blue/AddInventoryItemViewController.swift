//
//  AddInventoryItemViewController.swift
//  T02_Blue
//
//  Created by Saptami Biswas on 11/14/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

import UIKit



class AddInventoryItemViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addItemName: UITextField!
    @IBOutlet weak var addInventoryAmount: UITextField!
    @IBOutlet weak var addThresholdAmount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addItemName.delegate = self
        self.addInventoryAmount.delegate = self
        self.addThresholdAmount.delegate = self
        
        self.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
        
        self.addInventoryAmount.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.addInventoryAmount.resignFirstResponder()
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

//
//  AddNewClosetViewController.swift
//  T02_Blue
//
//  Created by Saptami Biswas on 11/14/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

import UIKit

class AddNewClosetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addClosetNumber: UITextField!
    @IBOutlet weak var addFloorNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addClosetNumber.delegate = self
        self.addFloorNumber.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

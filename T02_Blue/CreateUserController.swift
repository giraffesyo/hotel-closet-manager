//
//  CreaterUserController.swift
//  T02_Blue
//
//  Created by joshua mcmahan on 11/27/18.
//  Copyright © 2018 Team Blue. All rights reserved.
//

import UIKit

class CreateUserController: UIViewController {

    var db = InventoryDatabase.init()
    
    @IBOutlet var EmailInputBox: UITextField!
    @IBOutlet var PasswordInputBox: UITextField!
    @IBOutlet var AdministratorInputSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddPressed(_ sender: UIButton) {
        // get the form values
        let email: String = EmailInputBox?.text ?? ""
        let password: String = PasswordInputBox?.text ?? ""
        let shouldBeAdmin: Bool = AdministratorInputSwitch?.isOn ?? false
        
        if( email == "" || password == ""){
            //handle case email and password not entered
            return
        }
        //send the creation request over the network to our lambda function
        db.createAccount(email: email, password: password) { (Response) in
            
            let success = Response["success"] as! Bool
            if success{
                // we have their uid if it was successful
                let uid = Response["result"] as! String
                print("success")
            } else {
                //if not successful we have an error message
                let result = Response["result"] as! [String: String]
                print(result["message"])
                print("no bueno")
            }
        }
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

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
    @IBOutlet var SaveButton: LoadingButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddPressed(_ sender: UIButton) {
        SaveButton.showLoading()
        // get the form values
        let email: String = EmailInputBox?.text ?? ""
        let password: String = PasswordInputBox?.text ?? ""
        let shouldBeAdmin: Bool = AdministratorInputSwitch?.isOn ?? false
        
        if( email == "" || password == ""){
            SaveButton.hideLoading()
            //handle case email and password not entered
            return
        }
        //send the creation request over the network to our lambda function
        db.createAccount(email: email, password: password, isAdmin: shouldBeAdmin) { (Response) in
            let success = Response["success"] as! Bool
            if success{
                //clear the password textbox
                self.PasswordInputBox.text = ""
                // we have their uid if it was successful
                let title = "Success"
                let message = "Successfully created account"
                self.showAlert(title: title, message: message)
                self.SaveButton.hideLoading()
                //return to home screen
            } else {
                //if not successful we have an error message
                let result = Response["result"] as! [String: String]
                let message: String = result["message"] ?? "Account not created."
                self.showAlert(title: "Error", message: message)
                self.SaveButton.hideLoading()
            }
        }
    }
    
    
    func showAlert(title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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

//
//  EditUsersController.swift
//  T02_Blue
//
//  Created by joshua mcmahan on 11/27/18.
//  Copyright © 2018 Team Blue. All rights reserved.
//

import UIKit

class EditUsersController: UIViewController {

    
    var User: UserManagementController.User? = nil
    var db: InventoryDatabase = InventoryDatabase.init()
    @IBOutlet var EmailLabel: UILabel!
    @IBOutlet var AdministratorInputSwitch: UISwitch!
    @IBOutlet var SaveButton: LoadingButton!
    @IBOutlet var PasswordInputBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up the view with the user we get from the table view
        configureView()
    }
    
    func configureView() -> Void {
        EmailLabel.text = User?.email ?? ""
        AdministratorInputSwitch.isOn = User?.admin ?? false
    }

    @IBAction func SavePressed(_ sender: UIButton) {
        // start animating the button
        self.SaveButton.showLoading()
        
        //check if the password was changed
        let password = PasswordInputBox.text
        let PasswordChange: Bool = password != ""
        let admin = AdministratorInputSwitch.isOn
        let uid = User!.uid
        if PasswordChange {
            // this is a password change request
            db.updateUser(uid: uid, password: password!, admin: admin, completion: {Response in
                let success = Response["success"] as! Bool
                if success{
                    // we have their uid if it was successful
                    let title = "Success"
                    let message = "Successfully updated account."
                    self.PasswordInputBox.text = ""
                    self.showAlert(title: title, message: message)
                    self.SaveButton.hideLoading()
                    //return to home screen
                } else {
                    //if not successful we have an error message
                    let result = Response["result"] as! [String: String]
                    let message: String = result["message"] ?? "Account not updated."
                    self.showAlert(title: "Error", message: message)
                    self.SaveButton.hideLoading()
                }
            })
        } else {
            // this is just an admin update
            db.updateUser(uid: uid, admin: admin, completion: { () in
                self.showAlert(title: "Success", message: "Administrator successfully set.")
                self.SaveButton.hideLoading()
            })
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

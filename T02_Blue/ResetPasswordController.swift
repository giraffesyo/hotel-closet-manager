//
//  ResetPasswordController.swift
//  T02_Blue
//
//  Created by joshua mcmahan on 11/27/18.
//  Copyright © 2018 Team Blue. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordController: UIViewController {

    @IBOutlet weak var tbCurrentPassword: UITextField!
    @IBOutlet weak var tbNewPassword: UITextField!
    @IBOutlet weak var tbVarifyPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Auth.auth().currentUser?.email
        //let credential = EmailAuthProvider.credential(withEmail: String, password: String)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changePasswordAuth(_ sender: UIButton) {
        let currentPassword = tbCurrentPassword.text
        let newPassword = tbNewPassword.text
        let verifyPassword = tbVarifyPassword.text
        // Get current user
        let user = Auth.auth().currentUser
        // Get current user email
        let email = user?.email
        let credential = EmailAuthProvider.credential(withEmail: email!, password: currentPassword!)
        
        // Reauthenticate the current user
        user?.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
            if error != nil {
                self.showAlert(title: "Oops", message: error?.localizedDescription ?? "Authentication failed.")
            }else if newPassword != verifyPassword {
                self.showAlert(title: "Oops", message: error?.localizedDescription ?? "Passwords do not match.")
            }else if newPassword == verifyPassword{
                user?.updatePassword(to: newPassword!, completion: {(error) in
                    if error != nil {
                        self.showAlert(title: "Oops", message: error?.localizedDescription ?? "Failed to change password.")
                    }else {
                    let alert = UIAlertController(title: "Success", message: "Password Changed.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: {action in
                            self.goBack()
                        })
                        alert.addAction(action)
                        // show the alert even if this screen is no longer visible
                        // e.g. if the user clicked back but password still changed we should let them know
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil )
                    }
                })
            }
        })
    }
    
    @objc func goBack() -> Void {
        self.navigationController?.popViewController(animated: true)
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

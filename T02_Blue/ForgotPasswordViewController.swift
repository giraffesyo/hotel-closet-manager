//
//  ForgotPasswordViewController.swift
//  T02_Blue
//
//  Created by Saptami Biswas on 11/10/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

// TODO: overwrite the password that matches the entered email with the new entered password and store the new one in the database

import UIKit

class ThirdViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var securityQuestionView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var enterEmail: UITextField!
    @IBOutlet weak var securityQuestionDisplay: UILabel!
    @IBOutlet weak var securityAnswer: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        securityQuestionView.isHidden = true
        newPasswordView.isHidden = true
        
        enterEmail.delegate = self
        securityAnswer.delegate = self
        newPassword.delegate = self
        confirmPassword.delegate = self
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("debug 1")
        if textField === enterEmail {
            print("debug 2")
            //TODO: add logic to check value with values in the database, and move on if email is validated
            
            //TODO: retrieve security question and answer from database that match the entered email
            
            securityQuestionView.isHidden = false
            return true
        }
        else if textField === securityAnswer {
            
            //TODO: check security answer with retrieved answer from database
            
            newPasswordView.isHidden = false
            return true
        }
        else if textField === newPassword {
            
            //TODO: store the new password in a local variable
            
            return true
        }
        else if textField === confirmPassword {
            
            //TODO: check to ensure confirm password text matches with what was entered in new password
            
            return true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

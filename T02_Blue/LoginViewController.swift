//
//  LoginViewController.swift
//  T02_Blue
//
//  Created by Saptami Biswas on 11/9/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var createNewAccount: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timer = Timer.self
    var secondsRemaining = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        self.navigationController!.navigationBar.isHidden = true
        userIdTextField.delegate = self
        passwordTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton)
    {
        if userIdTextField.text == "" || passwordTextField.text == ""
        {
            showIncompleteFieldAlert()
        }
        else{
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) -> Void in
            self.activityIndicator.isHidden = false
            self.secondsRemaining -= 1
            self.activityIndicator.startAnimating()
            
            if self.secondsRemaining == 0 {
                
                timer.invalidate()
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "segueToInventoryFromLogin", sender: self)
                
            }
        })
        }
        /*In this function oyther details are to be added. That is if the entered email-id and password is not there in the database then it would show an alert to the user.*/
        
        //if incorrect email-id or password, then
        // call showAlert()
        
        //showAlert()
    }
    
    @IBAction func showIncompleteFieldAlert()
    {
        let alert = UIAlertController(title: "Incomplete Fields!", message: "Both the fields of e-mail id and password must be filled", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showAlert()
    {
        let alert = UIAlertController(title: "Oops", message: "The entered email-id and password does not exist. Please try again if you already have an account. If you are a new user then please register.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

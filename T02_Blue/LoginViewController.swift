//
//  LoginViewController.swift
//  T02_Blue

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var createNewAccount: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timer = Timer.self
    var secondsRemaining = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        userIdTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
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
       /* if userIdTextField.text == "" || passwordTextField.text == ""
        {
            showIncompleteFieldAlert()
        }*/
        self.performSegue(withIdentifier: "segueToInventoryFromLogin", sender: self)
        
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

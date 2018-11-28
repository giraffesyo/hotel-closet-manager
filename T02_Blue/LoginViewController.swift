//
//  LoginViewController.swift
//  T02_Blue

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var db: InventoryDatabase? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdTextField.delegate = self
        passwordTextField.delegate = self
        self.db = InventoryDatabase.init()

    }
    override func viewDidAppear(_ animated: Bool) {
        // if we're logged in segue to home screen
        if Auth.auth().currentUser != nil{
            self.goToHomeScreen()
        }
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
        // get username and password from the form
        let username: String = userIdTextField?.text ?? ""
        let password: String = passwordTextField?.text ?? ""
        // clear password box
        passwordTextField?.text = ""
        
        if username == "" || password == ""
        {
            showAlert(message: "Please enter your username and password")
        }
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
            if let user = user {
                //pass the user to our database to ensure it is part of the users db (separate from auth system)
                let uid: String = user.user.uid
                let email: String = user.user.email!
                self.db!.VerifyUserAgainstDb(uid: uid, email: email)
                
                // we sucessfully logged in, segue to logged in screen and clear textboxes
                self.userIdTextField?.text = ""
                self.goToHomeScreen()
            } else {
                // we have an error
                let message = error?.localizedDescription ?? "Something went wrong, sorry"
                self.showAlert(message: message)
            }
        }
    }
    
    func goToHomeScreen() -> Void {
        self.performSegue(withIdentifier: "to home screen", sender: self)
    }
    
    func showAlert(message: String) -> Void
    {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

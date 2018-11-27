//
//  LoadingViewController.swift
//  T02_Blue


import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if we're logged in segue to home screen otherwise go to login view
        if Auth.auth().currentUser != nil{
            self.goToHomeScreen()
        } else {
            self.goToLoginScreen()
        }
    }
    
    func goToHomeScreen() -> Void {
        self.performSegue(withIdentifier: "to home", sender: self)
        
    }
    
    func goToLoginScreen() -> Void {
        self.performSegue(withIdentifier: "to login", sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
    }
}


//
//  LoadingViewController.swift
//  T02_Blue


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToLoginScreen()

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


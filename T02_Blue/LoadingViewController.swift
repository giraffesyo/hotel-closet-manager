//
//  LoadingViewController.swift
//  T02_Blue
//
//  Created by Josh Sheridan on 11/9/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    var timer = Timer.self
    var secondsRemaining = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = true
        
        // Waits before seguing to the new view controller to set up all the databases
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) -> Void in
            
            self.secondsRemaining -= 1
            self.activityIndicator.startAnimating()
            
            if self.secondsRemaining == 0 {
                
                timer.invalidate()
                self.loginButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                self.performSegue(withIdentifier: "segueToSecondVC", sender: self)
                
            }
        })
    }
}

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
         self.performSegue(withIdentifier: "segueToSecondVC", sender: self)
        
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


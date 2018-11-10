//
//  ThirdViewController.swift
//  T02_Blue
//
//  Created by Saptami Biswas on 11/10/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterCodeTextField: UITextField!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    
    var remainingSeconds = 60
    //var timer: Timer.self

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func sendCodeAction(_ sender: UIButton) {

        sendCodeButton.isEnabled = false
        enterCodeTextField.delegate = self
        remainingTime.text = "01:00"
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) -> Void in
            // Decrement the seconds that remain.
            self.remainingSeconds -= 1
            
            if self.remainingSeconds == 0 {
                timer.invalidate()
                self.showAlert()
                self.sendCodeButton.isEnabled = true
                self.sendCodeButton.setTitle("Resend Code", for: .normal)
                self.sendCodeButton.backgroundColor = UIColor.red
                self.remainingSeconds = 60
                
            }
            
            
            self.remainingTime.text = "00:" + String(self.remainingSeconds)
        })
        //send a randomly generated 6-digit number to the registered email or mobile number
        if remainingSeconds == 0
        {
            }
    }
    
    @IBAction func resendCodeAction(_ sender: UIButton) {
    
        //resendCode
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func showAlert()
    {
        let alert = UIAlertController(title: "Timed out!", message: "If you did not recieve an email, try again by hitting the resend button", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

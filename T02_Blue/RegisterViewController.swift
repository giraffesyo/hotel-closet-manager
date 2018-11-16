//
//  RegisterViewController.swift
//  T02_Blue
//
//  Created by Saptami Biswas on 11/10/18.
//  Copyright © 2018 Josh Sheridan. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var employeeIdTextField: UITextField!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var securityAnswer: UITextField!    
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var questions = ["What was the name of your first school?",
                     "What was your first pet's name?",
                     "What was the first foriegn country you visited?",
                     "What is your mother's maiden name?",
                     "What is your favorite holiday destination?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func dropDownActionButton(_ sender: UIButton)
    {
        if tableView.isHidden{
            animate(toggle: true)
        }else{
            animate(toggle: false)
        }
    }

    func animate(toggle: Bool)
    {
        if toggle{
            UIView.animate(withDuration: 0.3)
            {
                self.tableView.isHidden = false
            }
        }
        else
        {
            UIView.animate(withDuration: 0.3)
            {
                    self.tableView.isHidden = true
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension FourthViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = questions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownButton.setTitle("\(questions[indexPath.row])", for: .normal)
        animate(toggle: false)
        dropDownButton.setTitleColor(UIColor.black, for: .normal)
    }
    
}

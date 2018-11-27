//
//  HomeViewController.swift
//  T02_Blue
//
//  Created by Michael McQuade on 11/25/18.
//  Copyright © 2018 Team Blue. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var InventoryStackView: UIStackView!
    @IBOutlet var PasswordStackView: UIStackView!
    @IBOutlet var LogoutStackView: UIStackView!
    @IBOutlet var UsersStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestures()
        //add tap gestures to our views
        
        // Do any additional setup after loading the view.
    }
    
    func setupTapGestures() {
        let inventoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.goToInventory))
        self.InventoryStackView.addGestureRecognizer(inventoryTapGesture)
        let passwordTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.goToPassword))
        self.PasswordStackView.addGestureRecognizer(passwordTapGesture)
        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.performLogout))
        LogoutStackView.addGestureRecognizer(logoutTapGesture)
        let usersTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.goToUsers))
        UsersStackView.addGestureRecognizer(usersTapGesture)
    }
    
    //Segue to the invetory closet view
    @objc func goToInventory() -> Void {
        performSegue(withIdentifier: "to inventory closets", sender: self)
    }
    //Segue to the password reset view
    @objc func goToPassword() -> Void {
        performSegue(withIdentifier: "to password reset", sender: self)
    }
    
    @objc func performLogout() -> Void {
        //todo
        print("not implemented")
    }
    //Segue to the users view
    @objc func goToUsers() -> Void {
        performSegue(withIdentifier: "to users", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

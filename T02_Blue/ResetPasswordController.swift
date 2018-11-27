//
//  ResetPasswordController.swift
//  T02_Blue
//
//  Created by joshua mcmahan on 11/27/18.
//  Copyright © 2018 Team Blue. All rights reserved.
//

import UIKit
import FirebaseAuth
class ResetPasswordController: UIViewController {

    @IBOutlet weak var tbCurrentPassword: UITextField!
    @IBOutlet weak var tbNewPassword: UITextField!
    @IBOutlet weak var tbVarifyPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Auth.auth().currentUser?.email
        //let credential = EmailAuthProvider.credential(withEmail: String, password: String)
        
        // Do any additional setup after loading the view.
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

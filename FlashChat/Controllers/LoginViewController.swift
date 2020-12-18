//
//  LoginViewController.swift
//  FlashChat
//
//  Created by Evgeniy Uskov on 19.12.2020.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            
            if error != nil {
                print("error: \(error!)")
            }
            else {
                print("log in succesful")
            }
            self.performSegue(withIdentifier: "goToChat", sender: self)
            SVProgressHUD.dismiss()
        }
        
    }
    


    
}


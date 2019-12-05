//
//  ViewController.swift
//  CityMap
//
//  Created by Michele Alfonso Pardo Pezzullo on 2/12/19.
//  Copyright © 2019 MICHELE ALFONSO PARDO PEZZULLO. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

  
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var btnGoogleSignIn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }

    @IBAction func signInTapped(_ sender: Any) {
        
        guard let usr = emailTxtField.text,
            let pwd = passwordTxtField.text
        else {
                return
        }
        Auth.auth().signIn(withEmail: usr, password: pwd){ [weak self] authResult,
            error in
            if (error == nil) {
                self?.openMapScreen()
            } else {
                print("Error creating user: \(String(describing: error))")
            }
            
        }
    }
    
    func openMapScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "map_screen")
        self.present(controller, animated: true, completion: nil)
    }

    
    
}


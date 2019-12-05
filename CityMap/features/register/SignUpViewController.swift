//
//  SignUpViewController.swift
//  CityMap
//
//  Created by Michele Alfonso Pardo Pezzullo on 2/12/19.
//  Copyright © 2019 MICHELE ALFONSO PARDO PEZZULLO. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class SignUpViewController: UIViewController {
    
    var uid: String?
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var surnameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        guard let usr = emailTxtField.text,
            let pwd = passwordTxtField.text,
            let name = nameTxtField.text,
            let surname = surnameTxtField.text else {
                return
        }
        
        Auth.auth().createUser(withEmail: usr, password: pwd) { authResult, error in
            if error == nil{
                guard let uid = Auth.auth().currentUser?.uid else { return }
                self.createCollection(uid: uid, name: name, surname: surname, mail: usr)
                //self.openMapScreen()
            } else {
                self.openMapScreen()
                print("Error creating user: \(String(describing: error))")
            }
            
            
        }
        
        }
    
    func createCollection(uid: String?, name: String, surname: String, mail: String){
        
        Firestore.firestore().collection("users").document(uid!).setData(["name": name,"surname":surname, "mail": mail]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
            
        }
    
    
    func openMapScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "map_screen")
        self.present(controller, animated: true, completion: nil)
    }
}

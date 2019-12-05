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
import CoreData

protocol ProfileDataDelegate {
    func setUserLocalData(name: String?, surname: String?, mail: String?)
}

class SignUpViewController: UIViewController {
    
    var uid: String?
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var surnameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
   
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    var delegate: ProfileDataDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        self.delegate = ProfileViewController() as! ProfileDataDelegate
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
                self.openMapScreen()
            } else {
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
        //lo comento por un error no resuelto
        //insertUserLocal(name: name, surname: surname, mail: mail)
    }
    
    func insertUserLocal(name: String, surname: String, mail: String){
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context!)
        let newUser = NSManagedObject(entity: entity!, insertInto: context!)
        newUser.setValue(name, forKey: "name")
        newUser.setValue(surname, forKey: "surname")
        newUser.setValue(mail, forKey: "email")
        do {
            try context?.save()
            sendLocalUserData()
            print("*****************DONE********************")
        } catch {
            print("Failed saving")
        }
        
    }
    
    func sendLocalUserData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as? String
                let surname = data.value(forKey: "surname") as? String
                let email = data.value(forKey: "email") as? String
                DispatchQueue.main.async {
                    self.delegate?.setUserLocalData(name: name, surname: surname, mail: email)
                }
               
        }
    
        } catch {
        print("Failed")
        }
}

    
    func openMapScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tabBar")
        self.present(controller, animated: true, completion: nil)
    }
    
    
}

//
//  ProfileViewController.swift
//  CityMap
//
//  Created by Michele Alfonso Pardo Pezzullo on 5/12/19.
//  Copyright © 2019 MICHELE ALFONSO PARDO PEZZULLO. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import CoreData

class ProfileViewController: UIViewController, GIDSignInUIDelegate, ProfileDataDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var surnameLbl: UILabel!
    
    @IBOutlet weak var emailLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setUserLocalData(name: String?, surname: String?, mail: String?) {
        //ERROR: no se como resolver este error, no lo entiendo, los parametros llegan con su debido contenido
        // y cuando trato de setear las labels me da nil por que dice que es nulo.
            nameLbl.text = name
            surnameLbl.text = surname
            emailLbl.text = mail
        
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance()?.signOut()
            openLoginScreen()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
//        //As we know that container is set up in the AppDelegates so we need to refer that container.
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        //We need to create a context from this container
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur3")
//
//        do
//        {
//            let test = try managedContext.fetch(fetchRequest)
//
//            let objectToDelete = test[0] as! NSManagedObject
//            managedContext.delete(objectToDelete)
//
//            do{
//                try managedContext.save()
//            }
//            catch
//            {
//                print(error)
//            }
//
//        }
//        catch
//        {
//            print(error)
//        }
        
    }
    
    func openLoginScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "login_screen")
        self.present(controller, animated: true, completion: nil)
    }
    
   

}

//
//  SignUpViewController.swift
//  CityMap
//
//  Created by Michele Alfonso Pardo Pezzullo on 2/12/19.
//  Copyright © 2019 MICHELE ALFONSO PARDO PEZZULLO. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var surnameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        
    }
    
}

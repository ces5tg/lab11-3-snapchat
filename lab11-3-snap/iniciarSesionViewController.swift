//
//  ViewController.swift
//  lab11-3-snap
//
//  Created by cesar pacho on 7/11/23.
//

import UIKit
import FirebaseAuth
class iniciarSesionViewController: UIViewController {
   

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func IniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text! , password:passwordTextField.text!){(user , error) in
                    print("intentando iniciar sesion")
                    if error != nil{
                        print("se presneto el siguiente error \(error)")
                    }else {
                        print("incio de sesion exitoro")
                    }
                }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


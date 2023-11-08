//
//  ViewController.swift
//  lab11-3-snap
//
//  Created by cesar pacho on 7/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
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
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            // ...
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in

              // At this point, our user is signed in
            }
                
        }
    }
    
    



    
}


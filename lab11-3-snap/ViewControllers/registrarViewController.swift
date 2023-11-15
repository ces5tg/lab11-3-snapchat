//
//  registrarViewController.swift
//  lab11-3-snap
//
//  Created by cesar pacho on 14/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseDatabase
class registrarViewController: UIViewController {
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    
    @IBAction func registrar(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.textFieldEmail.text!, password: self.textFieldPassword.text! , completion: {
            (user , error) in print("intentado crear usuario")
            if error != nil{
                print("se presento el siguiente error al crear usuario  \(error)")
            }else{
                print("el usuario fue creado satisfactoriament")
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                print("ir al segue")
                self.performSegue(withIdentifier: "segueRegister", sender: nil)
            }
        }
        )
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

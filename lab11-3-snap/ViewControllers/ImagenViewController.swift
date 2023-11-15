//
//  ImagenViewController.swift
//  lab11-3-snap
//
//  Created by cesar pacho on 14/11/23.
//

import UIKit
import FirebaseStorage
class ImagenViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true , completion: nil)
    }
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var UImageView: UIImageView!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        
        let imagesFolder = Storage.storage().reference().child("imagenes")
        let dataImagen = UImageView.image?.jpegData(compressionQuality: 0.5)
        
        let cargarImagen = imagesFolder.child("\(NSUUID().uuidString)").putData(dataImagen!, metadata: nil){
            (metadata , error ) in
            if error != nil {
                self.mostrarAlerta(titulo: "error", mensaje: "se produjo un error al subir la iagen", accion: "aceptar")
                print("ocurrio un error al subir la imagen \(error)")
            }else{
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
            }
        }
        let alertaCarga = UIAlertController(title: "cargando imagen", message: "0%", preferredStyle: .alert)
        let progresoCarga: UIProgressView = UIProgressView(progressViewStyle:.default)
        cargarImagen.observe(.progress){ (snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
            
            progresoCarga.setProgress(Float(porcentaje), animated: true)
            progresoCarga.frame = CGRect(x:10 , y:70 , width:250 , height: 0)
            alertaCarga.message = String(round(porcentaje*100.0)) + " %"
            if porcentaje >= 1.0{
                alertaCarga.dismiss(animated: true , completion: nil)
            }
        }
        let btnOk = UIAlertAction(title: "aceptar", style: .default , handler: nil)
        alertaCarga.addAction(btnOk)
        alertaCarga.view.addSubview(progresoCarga)
        present(alertaCarga , animated: true , completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        UImageView.image = image
        UImageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true ,completion: nil)
        
    }
    func mostrarAlerta(titulo:String , mensaje:String , accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCancelok = UIAlertAction(title: accion, style: .default , handler: nil)
        alerta.addAction(btnCancelok)
        present(alerta , animated:  true  , completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imagesFolder = Storage.storage().reference().child("imagenes")
        let dataImagen = UImageView.image?.jpegData(compressionQuality: 0.5)
        imagesFolder.child("imagenes.jpg").putData(dataImagen!, metadata: nil){
            (metadata , error ) in
            if error != nil {
                print("ocurrio un error al subir la imagen \(error)")
            }
        }
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

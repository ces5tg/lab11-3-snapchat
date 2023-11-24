//
//  ImagenViewController.swift
//  lab11-3-snap
//
//  Created by cesar pacho on 14/11/23.
//

import UIKit
import AVFoundation
import FirebaseStorage
class ImagenViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioID = NSUUID().uuidString
    
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
        
//        let cargarImagen = imagesFolder.child("\(imagenID).jpg")
//            cargarImagen.putData(dataImagen!, metadata: nil){
//            (metadata , error ) in
//            if error != nil {
//                self.mostrarAlerta(titulo: "error", mensaje: "se produjo un error al subir la iagen", accion: "aceptar")
//                print("ocurrio un error al subir la imagen \(error)")
//                return
//            }else{
//                cargarImagen.downloadURL(completion:{(url , error) in
//                    guard let enlaceURL = url else{
//                        self.mostrarAlerta(titulo: "error", mensaje: "se produjo un erro al obetener informacion de la imagen", accion: "cancelar")
//                        self.elegirContactoBoton.isEnabled = true
//                        print("ocurrio un erro al obtener inforamcion de imgen \(error)")
//                        return
//                        
//                    }
//                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender:url?.absoluteString)
//                })
//                
//            }
//        }
        let audiosFolder = Storage.storage().reference().child("audios")
        let dataAudio = audioURL?.dataRepresentation
        let cargarAudio = audiosFolder.child("\(audioID).m4a")
            cargarAudio.putData(dataAudio!, metadata: nil){
            (metadata , error ) in
            if error != nil {
                self.mostrarAlerta(titulo: "error", mensaje: "se produjo un error al subir la iagen", accion: "aceptar")
                print("ocurrio un error al subir la imagen \(error)")
                return
            }else{
                cargarAudio.downloadURL(completion:{(url , error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "error", mensaje: "se produjo un erro al obetener informacion de la imagen", accion: "cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("ocurrio un erro al obtener inforamcion de imgen \(error)")
                        return
                        
                    }
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender:url?.absoluteString)
                })
                
            }
        }

    }
    var grabarAudio: AVAudioRecorder?
        var reproducirAudio:AVAudioPlayer?
    
    
        var audioURL:URL?

    @IBOutlet weak var grabarReproducir: UIButton!
    @IBOutlet weak var grabarButton: UIButton!
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
            grabarAudio?.stop()
            grabarButton.setTitle("GRABAR", for: .normal)
            grabarReproducir.isEnabled  = true
            
        } else {
            
            grabarAudio?.record()
            grabarButton.setTitle("Detener", for: .normal)
            grabarReproducir.isEnabled  = false
            
        }
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        do {
            //audio2.play()
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("reproduciendo ... ")
        }catch {
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        self.configurarGrabacion()
        
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
    
    func configurarGrabacion(){
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord , mode :AVAudioSession.Mode.default , options:[])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath , "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*******+")
            print(audioURL!)
            print("*******+")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //            var settings: [String: Any] = [
            //                AVFormatIDKey: kAudioFormatMPEG4AAC,
            //                AVSampleRateKey: 44100.0,
            //                AVNumberOfChannelsKey: 2,
            //                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            //            ]
            
            grabarAudio = try AVAudioRecorder(url:audioURL! , settings:settings)
            grabarAudio!.prepareToRecord()
            
            
        }catch let error as NSError{
            print(error)
        }
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //        let imagesFolder = Storage.storage().reference().child("imagenes")
            //        let dataImagen = UImageView.image?.jpegData(compressionQuality: 0.5)
            //        imagesFolder.child("imagenes.jpg").putData(dataImagen!, metadata: nil){
            //            (metadata , error ) in
            //            if error != nil {
            //                print("ocurrio un error al subir la imagen \(error)")
            //            }
            //        }
            let siguienteVC = segue.destination as! ElegirUsuarioViewController
            siguienteVC.imagenURL = sender as! String
            siguienteVC.descrip = TextField.text!
            siguienteVC.imagenID = imagenID
            siguienteVC.audioID = sender as! String
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

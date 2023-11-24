//
//  VerSnapViewController.swift
//  lab11-3-snap
//
//  Created by cesar pacho on 21/11/23.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import AVFoundation
class VerSnapViewController: UIViewController {
    var reproducirAudio:AVPlayer?
    @IBOutlet weak var lblMensaje: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var snap = Snap()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensa" + snap.descrip
        imageView.sd_setImage(with:URL(string:snap.imagenURL) , completed:nil)
        print("=======================")
        print(snap.audioID)
       let audioURL = URL(string: snap.audioID)
            reproducirAudio = AVPlayer(url: audioURL)
            reproducirAudio?.play()
        // Llamar a la función play pasando la URL
       play(url: audioURL)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
//        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
//        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{(error) in print("se elimino la imagen coretment")}
    }
    func play(url:NSURL){
            print("playing \(url)")
            
            do{
                let player = try AVAudioPlayer(contentsOf: url as URL)
                player.prepareToPlay()
                player.play()
            }catch let error as NSError{
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

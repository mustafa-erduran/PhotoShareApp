//
//  UploadViewController.swift
//  PhotoShareApp
//
//  Created by Mustafa Erduran on 6.10.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    private let authentication = Auth.auth()
    private let firestoreDatabase = Firestore.firestore()
    private let storageReference = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func selectImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upload(_ sender: Any) {
        
        self.uploadButton.isEnabled = false
        self.createStorage()
    }
    
    
    
    private func uploadPost(url: URL){
        if (self.authentication.currentUser != nil) {
            let imageUrl = url.absoluteString
            let post = Post(imageUrl: imageUrl, comment: self.commentText.text! , email: Auth.auth().currentUser!.email!, date: FieldValue.serverTimestamp())
            self.firestoreDatabase.collection("Post").addDocument(data: post.postDictionary) { (error) in
                if error != nil{
                    self.errorMessage(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    self.commentText.text = ""
                    self.tabBarController?.selectedIndex = 0
                    self.uploadButton.isEnabled = true
                    
                }
            }
        }
        
    }
    
    
    private func errorMessage(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
    }
    
    private func createStorage(){
        
        let mediaFolder = self.storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { storagemetadata, error in
                if error != nil {
                    self.errorMessage(titleInput: "Error", messageInput: error?.localizedDescription ?? "Try Again")
                }else {
                    imageReference.downloadURL { url, error in
                        if error == nil && url != nil {
                            self.uploadPost(url: url!)
                        }
                    }
                }
            }
        }
    }
    
}

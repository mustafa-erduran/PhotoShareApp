//View.ViewController
//  ViewController.swift
//  PhotoShareApp
//
//  Created by Mustafa Erduran on 6.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func logIn(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authDataResult, error in
                if error != nil{
                    self.errorMessage(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata!")
                    
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
                
        }else {
            errorMessage(titleInput: "Hata!", messageInput: "email and password cannot be empty!")
        }
        
    }
    @IBAction func signIn(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authDataResult, error in
                if error != nil{
                    self.errorMessage(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata!")
                    
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            errorMessage(titleInput: "Hata!", messageInput: "email and password cannot be empty!")
        }
        
    }
    
    func errorMessage(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
    }
    
}


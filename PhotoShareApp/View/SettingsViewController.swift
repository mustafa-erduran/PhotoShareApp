//
//  SettingsViewController.swift
//  PhotoShareApp
//
//  Created by Mustafa Erduran on 6.10.2022.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func exit(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toStartPage", sender: nil)
        }catch{
            print("Hata")
        }
    }
    
    

}

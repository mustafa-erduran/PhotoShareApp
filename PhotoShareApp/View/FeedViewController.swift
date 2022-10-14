//
//  FeedViewController.swift
//  PhotoShareApp
//
//  Created by Mustafa Erduran on 6.10.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private let firestoreDatabase = Firestore.firestore()
    private var postArray : [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirebase()
    }
    
    func getDataFromFirebase(){
        firestoreDatabase.collection("Post").order(by: "time", descending: true)
            .addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.postArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        if let imageUrl = document.get("imageUrl") as? String{
                            if let comment = document.get("comment") as? String{
                                if let email = document.get("email") as? String{
                                    if let date = document.get("time"){
                                        let post = Post(imageUrl: imageUrl, comment: comment, email: email, date: FieldValue.serverTimestamp())
                                        self.postArray.append(post)
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.commentText.text = postArray[indexPath.row].comment
        cell.emailText.text = postArray[indexPath.row].email
        cell.commentText.textColor = .blue
        cell.emailText.textColor = .red
        cell.postImageView.sd_setImage(with: URL(string: postArray[indexPath.row].imageUrl!))
//        if let imageURL = URL(string : postArray[indexPath.row].imageUrl ?? ""){
//            DispatchQueue.global().async {
//                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
//
//                    let image = UIImage(data: imageData)
//                    DispatchQueue.main.async {
//                        cell.postImageView.image = image
//                    }
//                }
//        }
        
        return cell
        
        
    }
}

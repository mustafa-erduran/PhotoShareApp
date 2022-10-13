//
//  Post.swift
//  PhotoShareApp
//
//  Created by Mustafa Erduran on 13.10.2022.
//

import Foundation
import Firebase
import FirebaseAuth

class Post {
    
    public var imageUrl: String?
    public var comment: String?
    public var email: String?
    public var date: FieldValue?
    
    
    init(imageUrl : String, comment : String, email: String, date: FieldValue){
        self.imageUrl = imageUrl
        self.comment = comment
        self.email = email
        self.date = date
    }
    
    var postDictionary: [String : Any]{
        return ["imageUrl" : self.imageUrl!, "comment" : self.comment!, "email" : self.email!, "time" : self.date as Any]
    }
    
    
    
}

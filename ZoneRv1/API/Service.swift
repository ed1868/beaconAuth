//
//  Service.swift
//  TheBoys
//
//  Created by Eddie Ruiz on 8/19/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Foundation
import Firebase

struct Service {
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void ){
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    static func fetchUsers(completion: @escaping([User]) -> Void){
        var users = [User]()
        COLLECTION_USERS.getDocuments { snapshot, error in
           
  
            snapshot?.documents.forEach({ document in
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                
                users.append(user)
                completion(users)
            })
        }
    }
    
    
   static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["text" : message,
                    "fromId" : currentUid,
                    "toId" :   user.uid,
                    "timestamp" : Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_MESSAGE.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            COLLECTION_MESSAGE.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            COLLECTION_MESSAGE.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
    
    
            COLLECTION_MESSAGE.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
    }
    
        
    }
    
    static func fetchCoversations(completion: @escaping([Payload]) -> Void) {
        var conversations = [Payload]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGE.document(uid).collection("recent-messages").order(by: "timestamp" )
        
        query.addSnapshotListener { (snapshot, error) in
            
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                
                let message = Payload(dictionary: dictionary)
                self.fetchUser(withUid: message.beaconId) { user in
                    let conversation = Payload(dictionary: user )
                    
                    conversations.append(conversation)
                    completion(conversations)
                }
                
            })
        }
        
        
        
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping([Payload]) -> Void) {
        var messages = [Message]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        let query = COLLECTION_MESSAGE.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { ( snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    
                    completion(messages)
                }
            })
        }
    }
}

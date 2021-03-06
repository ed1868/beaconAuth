//
//  AuthService.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 9/2/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Firebase

struct registrationCredentials {
    let email  : String
    let password : String
    let username : String
    let fullname : String
    let profileImage : UIImage
    let beaconId : String
    let beaconPromotion : String
    
}


struct AuthService{
    static let shared = AuthService()
    
    func logUserIn(withEmail email:String, password: String, completion: AuthDataResultCallback?) {
                Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    
    func createUser(credentials : registrationCredentials , completion: ((Error?) -> Void)?) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        print("ENTROOOOOO")
        print("----image data--- \(imageData)")
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        print("----:D :D---")
        ref.putData(imageData, metadata: nil){ (meta,error) in
            if let error = error {
                print("DEBUG: FAILED TO UPLOAD IMAGE WITH ERROR \(error.localizedDescription)")
            }
            
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                
                 // WE HAVE TO CREATE USER
                let elPassword = "eddie123456"
                Auth.auth().createUser(withEmail: credentials.email, password: elPassword) { (result, error) in
                    if let error = error {
                            print("DEBUG: ERRRRROOOOORORRRRFAILED TO CREATE USER WITH ERROR \(error.localizedDescription)")
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    print("----:D\(credentials) :D---")

                    let data = [ "email": credentials.email,
                                 "fullname": credentials.fullname,
                                 "profileImageUrl": profileImageUrl,
                                 "uid": uid,
                                 "username": credentials.username,
                                 "beaconID": credentials.beaconId,
                                 "beaconPromotion": credentials.beaconPromotion
                    ] as [String: Any]
                    
                    // WE HAVE TO UPLOAD THE USER DATA TO DB
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
              

                }
            }
        }
    }
}

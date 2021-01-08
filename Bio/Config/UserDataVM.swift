//
//  UserDataVM.swift
//  Bio
//
//  Created by Andrew Williamson on 12/2/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation
import Firebase

class UserDataVM {
    var userData = LiveData<UserData?>(nil)
    var userDataRef = LiveData<DocumentReference?>(nil)
    
    let db = Firestore.firestore()
    var listener: ListenerRegistration?
    
    convenience init(username: String) {
        self.init()
        retreiveUserData(username: username, completion: {})

    }
    
    convenience init(email: String) {
        self.init()
        retreiveUserData(email: email, completion: {})
    }
    
    func retreiveUserData(username: String, completion: @escaping () -> ()) {
        print("initializing userdata with username: \(username)")
        listener?.remove()
        listener = db.collection("UserData1").whereField("publicID", isEqualTo: username).addSnapshotListener { obj, error in
            guard let docs = obj?.documents else {
                completion()
                return
            }
            if docs.count != 1 {
                print("Userdata docs count is \(docs.count)")
                completion()
                return
            }
            else{
                self.userData.value = UserData(dictionary: docs[0].data())
                self.userDataRef.value = docs[0].reference
                completion()
            }
        }
    }
    
    func retreiveUserData(email: String, completion: @escaping () -> ()) {
        print("initializing userdata with email: \(email)")
        listener?.remove()
        listener = db.collection("UserData1").whereField("email", isEqualTo: email).addSnapshotListener { obj, error in
            guard let docs = obj?.documents else {
                completion()
                return
            }
            if docs.count != 1 {
                completion()
                print("Userdata docs count is \(docs.count)")
                return
            }
            else{
                self.userData.value = UserData(dictionary: docs[0].data())
                self.userDataRef.value = docs[0].reference
                completion()
            }
        }
    }
    
    func updateUserData(newUserData: UserData, completion: @escaping (Bool) -> Void) {
        if newUserData.privateID != self.userData.value?.privateID {
            print("updating different userDatas")
            completion(false)
            return
        }
        else {
            userDataRef.value?.setData(newUserData.dictionary)
            completion(true)
        }
    }
    
    func kill() {
        userData.value = nil
        userDataRef.value = nil
        listener?.remove()
    }
}

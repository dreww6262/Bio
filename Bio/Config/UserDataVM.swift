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
                let ud = UserData(dictionary: docs[0].data())
                self.db.collection("FCMToken").whereField("publicID", isEqualTo: ud.publicID).getDocuments(completion: { obj, error in
                    guard let docs = obj?.documents else {
                        return
                    }
                    guard let fcmToken = Messaging.messaging().fcmToken else {
                        return
                    }
                    var fcmList: [String]
                    if docs.count == 0 {
                        self.db.collection("FCMToken").addDocument(data: ["publicID": ud.publicID, "fcmTokens": [fcmToken]])
                        return
                    }
                    else if docs.count == 1 {
                        fcmList = (docs[0]["fcmTokens"] as? [String]) ?? [String]()
                        if !fcmList.contains(fcmToken) {
                            fcmList.append(fcmToken)
                        }
                    }
                    else {
                        fcmList = (docs[0]["fcmTokens"] as? [String]) ?? [String]()
                        if !fcmList.contains(fcmToken) {
                            fcmList.append(fcmToken)
                        }
                        var first = true
                        for doc in docs {
                            if first {
                                first = false
                                continue
                            }
                            let tList = (doc["fcmTokens"] as? [String]) ?? [String]()
                            for item in tList {
                                if !fcmList.contains(item) {
                                    fcmList.append(item)
                                }
                            }
                            doc.reference.delete()
                        }
                    }
                    docs[0].reference.setData(["publicID": ud.publicID, "fcmTokens": fcmList])
                })
                self.userData.value = ud
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

//
// FireDBHelper.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-11-29.
// 
//
// 
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class FireDBHelper : ObservableObject{
    
    @Published var userList = [User]()
    @Published var currentUser : User?
    
    var documentID: String?
    private static var shared : FireDBHelper?
    var db : Firestore
    
    private let COLLECTION_FRIENDS = "Friends"
    private let COLLECTION_USERS = "Users"
    private let ATTRIBUTE_USERNAME = "username"
    private let ATTRIBUTE_NAME = "name"
    
    init(database : Firestore){
        self.db = database
        db.collection("Users").getDocuments { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documents{
                
                let id = i.documentID
                let username = i.get("username") as? String ?? "NA"
                let name = i.get("name") as? String ?? "NA"
                let secretSantaOf = i.get("secretSantaOf") as? String ?? "NA"
                
                let user = User(id: id, username: username, name: name, secretSantaOf: secretSantaOf)
                self.userList.append(user)
                if let userEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL"), userEmail == username {
                    // Set the matched user as the current user
                    self.currentUser = user
                    
                    if let currentUserData = try? NSKeyedArchiver.archivedData(withRootObject: self.currentUser, requiringSecureCoding: false) {
                        let sharedDefaults = UserDefaults(suiteName: "group.com.akhtahan.secretsanta")
                        sharedDefaults?.set(currentUserData, forKey: "USER")
                        sharedDefaults?.synchronize()
                    }
                    
                }
                
            }
        }
    }
    
    static func getInstance() -> FireDBHelper{
        
        if(self.shared == nil){
            self.shared = FireDBHelper(database: Firestore.firestore())
        }
        
        return self.shared!
    }
    
    func insertUser(user : User){
        
        let loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? "NA"
        
        do{
            if (loggedInUserEmail != "NA"){
                try self.db
                    .collection(self.COLLECTION_USERS)
                    .addDocument(from: user)
                
            }else{
                print(#function, "Unable to create user. You must login first.")
            }
            
        }catch let err as NSError{
            print(#function, "Unable to insert due to error  : \(err)")
        }
    }
    
    func insertFriend(user: User, completion: @escaping () -> Void) {
        let userID = UserDefaults.standard.string(forKey: "KEY_USER_ID") ?? "NA"
        
        self.db.collection(COLLECTION_USERS)
            .whereField("id", isEqualTo: userID)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in snapshot!.documents {
                        self.documentID = document.documentID
                        print("Document ID for user with ID \(userID): \(self.documentID ?? "N/A")")
                        
                        do {
                            if userID != "NA" {
                                try self.db
                                    .collection(self.COLLECTION_USERS)
                                    .document(self.documentID ?? "NA")
                                    .collection("friends")
                                    .addDocument(from: user)
                                
                                print("\(self.documentID ?? "NA")")
                                print("Friend added successfully!")
                                
                                completion()
                            } else {
                                print(#function, "Unable to add friend. You must log in first.")
                            }
                        } catch let err as NSError {
                            print(#function, "Unable to add friend due to error  : \(err)")
                        }
                    }
                }
            }
    }//insert
    
    func retrieveFriends(completion: @escaping ([User]) -> Void) {
        let userID = UserDefaults.standard.string(forKey: "KEY_USER_ID") ?? "NA"
        
        self.db.collection(COLLECTION_USERS)
            .whereField("id", isEqualTo: userID)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        print("Document ID for user with ID \(userID): \(documentID)")
                        
                        // Use the document id to retrieve friends
                        self.db.collection(self.COLLECTION_USERS)
                            .document(documentID)
                            .collection("friends")
                            .getDocuments { (friendsSnapshot, friendsError) in
                                if let friendsError = friendsError {
                                    print("Error getting friends: \(friendsError)")
                                } else {
                                    var friends: [User] = []
                                    for friendDocument in friendsSnapshot!.documents {
                                        do {
                                            if let friend = try? friendDocument.data(as: User.self) {
                                                friends.append(friend)
                                            }
                                        } catch let decodingError {
                                            print("Error decoding friend document: \(decodingError)")
                                        }
                                    }
                                    
                                    // Set the friendsList property of the current user
                                    self.currentUser?.friendsList = friends
                                    
                                    print("Current user's friendsList: \(self.currentUser?.friendsList ?? [])")
                                    
                                    completion(friends)
                                }
                            }
                    }
                }
            }
    }//retrieve friend
    
    func deleteFriend(userToDelete: User, completion: @escaping () -> Void) {
        let userID = UserDefaults.standard.string(forKey: "KEY_USER_ID") ?? "NA"
        
        self.db.collection(COLLECTION_USERS)
            .whereField("id", isEqualTo: userID)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        print("Document ID for user with ID \(userID): \(documentID)")
                        
                        
                        if userID != "NA" {
                            // find the friend to delete
                            let friendQuery = self.db.collection(self.COLLECTION_USERS)
                                .document(documentID)
                                .collection("friends")
                                .whereField("id", isEqualTo: userToDelete.id ?? "")
                            
                            // perform the delete
                            friendQuery.getDocuments { (friendSnapshot, friendError) in
                                if let friendError = friendError {
                                    print("Error getting friend documents: \(friendError)")
                                } else {
                                    for friendDocument in friendSnapshot!.documents {
                                        let friendDocID = friendDocument.documentID
                                        
                                        self.db.collection(self.COLLECTION_USERS)
                                            .document(documentID)
                                            .collection("friends")
                                            .document(friendDocID)
                                            .delete { error in
                                                if let error = error {
                                                    print("Error deleting friend: \(error)")
                                                } else {
                                                    print("Friend deleted successfully!")
                                                    // call completion handler
                                                    completion()
                                                }
                                            }
                                    }
                                }
                            }
                        } else {
                            print(#function, "Unable to delete friend. You must log in first.")
                        }
                    }
                }
            }
    }//delete friend
    
    func assignUserAsSecretSanta(completion: @escaping () -> Void) {
        
        let userID = UserDefaults.standard.string(forKey: "KEY_USER_ID") ?? "NA"
        
        self.db.collection(COLLECTION_USERS)
            .whereField("id", isEqualTo: userID)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        print("Document ID for user with ID \(userID): \(documentID)")
                        
                        self.db.collection(self.COLLECTION_USERS)
                            .document(documentID)
                            .collection("friends")
                            .getDocuments { (friendsSnapshot, friendsError) in
                                if let friendsError = friendsError {
                                    print("Error getting friends: \(friendsError)")
                                }
                                else{
                                    var friends: [User] = []
                                    for friendDocument in friendsSnapshot!.documents {
                                        self.documentID = friendDocument.documentID
                                        
                                        if var friend = try? friendDocument.data(as: User.self) {
                                            friends.append(friend)
                                        }
                                        
                                        friends.shuffle()
                                        
                                        self.currentUser?.secretSantaOf = String(friends.first?.username ?? "NA")
                                        self.db.collection(self.COLLECTION_USERS)
                                            .document(documentID)
                                            .updateData(["secretSantaOf": self.currentUser?.secretSantaOf!])
                                        
                                    }
                                    completion()
                                }
                            }
                    }
                }
            }
    } // assignSecretSanta
    
    func retrieveSecretSanta(completion: @escaping (User) -> Void){
        let userID = UserDefaults.standard.string(forKey: "KEY_USER_ID") ?? "NA"
        self.db.collection(COLLECTION_USERS)
//            .whereField("id", isEqualTo: userID)
//            .limit(to: 1)
            .document(userID)
            .getDocument { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let userData = try? snapshot?.data(as: User.self) {
                        self.currentUser = userData
                        
                        completion(userData)
                        print("Current User : \(userData)")
                    }
                }
            }

    }
    
    func updateUserDetails() {
        
        let userID = UserDefaults.standard.string(forKey: "KEY_USER_ID") ?? "NA"
        
        self.db.collection(COLLECTION_USERS)
            .whereField("id", isEqualTo: userID)
            .limit(to: 1)
            .getDocuments { [self] (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in snapshot!.documents {
                        self.documentID = document.documentID
                        print("Document ID for user with ID \(userID): \(self.documentID ?? "N/A")")
                        // Now you can use self.documentID as needed
                        
                        do {
                            if userID != "NA" {
                                try self.db
                                    .collection(self.COLLECTION_USERS)
                                    .document(self.documentID ?? "NA")
                                    .updateData([
                                        ATTRIBUTE_USERNAME: self.currentUser?.username ?? "NA"
                                        
                                    ]){error in
                                            
                                    if let err = error {
                                        print(#function, "Unable to update document due to error : \(err)")
                                    }else{
                                        print(#function, "Document successfully updated")
                                    }
                                }
                                
                            } else {
                                print(#function, "Unable to add wish. You must log in first.")
                            }
                        } catch let err as NSError {
                            print(#function, "Unable to add wish due to error  : \(err)")
                        }
                    }
                }
            }
    }
    
    func retrieveUserDetails(completion: @escaping (User) -> Void) {
        
        let userID = UserDefaults.standard.string(forKey: "KEY_USER_ID") ?? "NA"
        
        self.db.collection(COLLECTION_USERS)
            .whereField("id", isEqualTo: userID)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting user details: \(error)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("User document not found")
                    return
                }
                
                do {
                    if let user = try document.data(as: User?.self) {
                        completion(user)
                    } else {
                        print("Error decoding user data")
                    }
                } catch {
                    print("Error decoding user data: \(error)")
                }
            }
    }
}

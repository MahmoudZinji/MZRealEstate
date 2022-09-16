//
//  FirebaseUserManager.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-06.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI
import CoreLocation

class FirebaseUserManager: NSObject, ObservableObject {

    @Published var user: User = .init()
    let auth: Auth
    let firestore: Firestore
    let storage: Storage

    override init() {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        super.init()
        fetchUser()
    }

    func fetchUser() {
        guard let userID = auth.currentUser?.uid else { return }
        firestore.collection("users").document(userID).getDocument { documentSnapshot, error in
            if let error = error {
                print("DEBUG: error while Fetching User \(error.localizedDescription)")
                return
            }
            guard let user = try? documentSnapshot?.data(as: User.self) else { return }
            self.user = user
        }
    }

    func logUserIn(email: String, password: String, completion: @escaping ( (Bool) -> () ) ) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("DEBUG: error while Signing In \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func logout( completion: @escaping((Bool) -> ()) ) {
        do {
            try auth.signOut()
            self.user = .init()
            completion(true)
        } catch {
            print("DEBUG: error while logging out \(error.localizedDescription)")
            completion(false)
        }
    }

    func updateUserName(username: String, completion: @escaping ( (Bool) -> () )) {
        user.username = username
        try? firestore.collection("users").document(self.user.id).setData(from: user, merge: true) { error in
            if let error = error {
                print("DEBUG: error while Updating User Name \(error.localizedDescription)")
                completion(false)
            }
            completion(true)
        }
    }

    func updateDayTimeAvailability() {
        try? firestore.collection("users").document(self.user.id).setData(from: user, merge: true)
    }

    func createNewUser(email: String, password: String, username: String, profileImage: UIImage?, location: CLLocationCoordinate2D ,completion: @escaping( (Bool) -> () )) {
        print("DEBUG: 1")
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("DEBUG: error while creating account \(error.localizedDescription)")
                completion(false)
                return
            }
            print("DEBUG: 2")
            guard let userID = authResult?.user.uid else { return }

            self.uploadProfileImageToStorage(userId: userID, profileImage: profileImage) { profileImageUrlString in
                print("DEBUG: 5")
                let user = User(
                    id: userID,
                    profileImageUrl: profileImageUrlString,
                    favoriteRealEstate: [],
                    realEstates: [],
                    phoneNumber: "",
                    email: email,
                    username: username,
                    isVerified: false,
                    dayTimeAvailability: [
                        .init(day: .monday, fromTime: Date(), toTime: Date()),
                        .init(day: .tuesday, fromTime: Date(), toTime: Date()),
                        .init(day: .wednesday, fromTime: Date(), toTime: Date()),
                        .init(day: .thursday, fromTime: Date(), toTime: Date()),
                        .init(day: .friday, fromTime: Date(), toTime: Date())
                    ],
                    location: location
                )

                self.firestore.collection("users").document(userID).setData(user.dictionary)
                completion(true)
                print("DEBUG: 6")
            }
        }
    }

    func uploadProfileImageToStorage(userId: String, profileImage: UIImage?, completion: @escaping ( (String) -> () )) {
        print("DEBUG: 3")
        let profileImageId = UUID().uuidString

        if let profileImage {
            guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else { return }
            let ref = storage.reference(withPath: userId + "/" + profileImageId)

            ref.putData(imageData, metadata: nil) { storageMetaData, error in
                if let error = error {
                    print("DEBUG: error while uploading profile image \(error.localizedDescription)")
                    return
                }

                ref.downloadURL { imageURL, error in
                    if let error = error {
                        print("DEBUG: error while downloading image url \(error.localizedDescription)")
                        return
                    }

                    guard let profileImageUrlString = imageURL?.absoluteString else { return }
                    completion(profileImageUrlString)
                    print("DEBUG: 4")
                }
            }
        } else {
            completion("")
        }
    }
}

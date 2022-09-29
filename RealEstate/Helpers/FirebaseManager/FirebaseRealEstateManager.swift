//
//  FirebaseRealEstateManager.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

class FirebaseRealEstateManager: NSObject, ObservableObject {

    @Published var realEstates: [RealEstate] = []
    @Published var myRealEstates: [RealEstate] = []
    @Published var bookmarkedRealEstates: [RealEstate] = []

    let auth: Auth
    let firestore: Firestore
    let storage: Storage

    override init() {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        super.init()
        fetchRealEstates()
        fetchMyRealEstates()
        fetchMyBookmarkRealEstates()
    }

    func fetchMyBookmarkRealEstates() {
        guard let userId = auth.currentUser?.uid else { return }
        firestore.collection("users").document(userId)
            .collection("bookmarks").addSnapshotListener { querySnapshot, error in
                guard let bookmarkedRealEstates = querySnapshot?.documents.compactMap({ try? $0.data(as: RealEstate.self) }) else { return }
                self.bookmarkedRealEstates = bookmarkedRealEstates
            }
    }

    func markRealEstateAs(realEstate: RealEstate) {
        try? self.firestore
            .collection("users")
            .document(realEstate.ownerId)
            .collection("realEstates")
            .document(realEstate.id)
            .setData(from: realEstate)

        self.firestore
            .collection("realEstates")
            .document(realEstate.id)
            .delete()
    }

    func reAddRealEstate(realEstate: RealEstate) {
        try? self.firestore
            .collection("realEstates")
            .document(realEstate.id)
            .setData(from: realEstate)

        try? self.firestore
            .collection("users")
            .document(realEstate.ownerId)
            .collection("realEstates")
            .document(realEstate.id)
            .setData(from: realEstate)
    }

    func fetchRealEstates() {
        firestore.collection("realEstates").addSnapshotListener { querySnapshot, error in
            if let error = error{
                print("DEBUG: Error while fetching real Estates \(error)")
                return
            }

            guard let realEstates = querySnapshot?.documents.compactMap({try? $0.data(as: RealEstate.self)}) else { return }
            self.realEstates = realEstates.sorted { $0.isAvailable && !$1.isAvailable }
        }
    }

    func bookmarkRealEstate(realEstate: RealEstate, userId: String) {
        try? firestore.collection("users").document(userId)
            .collection("bookmarks").document(realEstate.id)
            .setData(from: realEstate)
    }

    func removeRealEstateFromBookmarks(realEstate: RealEstate) {
        try? firestore.collection("users").document(userId)
            .collection("bookmarks").document(realEstate.id)
            .delete()
    }

    func fetchOwnerDetails(userId: String, completion: @escaping( (User) -> () )) {
        firestore.collection("users").document(userId).addSnapshotListener { documentSnapshot, error in
            if let error = error{
                print("DEBUG: Error while fetching Owner Details \(error)")
                return
            }
            guard let userOwner = try? documentSnapshot?.data(as: User.self) else { return }
            completion(userOwner)
        }
    }

    func addRealEstate(realEstate: RealEstate,
                       images: [UIImage],
                       videoUrl: URL,
                       completion: @escaping( (Bool) -> () )) {
        var realEstate = realEstate
        uploadVideoToStorage(videoUrl: videoUrl) { videoUrlString in
            realEstate.videoUrlString = videoUrlString
            self.uploadImagesToStorage(images: images) { imageUrlString in
                realEstate.images = imageUrlString

                try? self.firestore
                    .collection("realEstates")
                    .document(realEstate.id)
                    .setData(from: realEstate)
                try? self.firestore
                    .collection("users")
                    .document(realEstate.ownerId)
                    .collection("realEstates")
                    .document(realEstate.id)
                    .setData(from: realEstate)
                completion(true)
            }
        }
    }

    func fetchMyRealEstates() {
        guard let userId = auth.currentUser?.uid else { return }
        firestore.collection("users").document(userId).collection("realEstates").addSnapshotListener { querySnapshot, error in
            if let error = error{
                print("DEBUG: Error while fetching my real estates \(error)")
                return
            }

            guard let myRealEstates = querySnapshot?.documents.compactMap({ try? $0.data(as: RealEstate.self)}) else { return }
            self.myRealEstate = myRealEstates
        }
    }

    func uploadVideoToStorage(videoUrl: URL, onCompletion: @escaping( (String) -> () )) {
        guard let userId = auth.currentUser?.uid else { return }
        do {
            let videoData = try Data(contentsOf: videoUrl)
            let videoFileName: String = UUID().uuidString
            let refStorage = storage.reference(withPath: userId + "/" + videoFileName + "/" + videoUrl.lastPathComponent)

            refStorage.putData(videoData, metadata: nil) { storageMetaData, error in
                if let error = error{
                    print("DEBUG: Error while uploading Video \(error)")
                    return
                }
                refStorage.downloadURL { videoUrl, error in
                    if let error = error{
                        print("DEBUG: Error while downloading Video \(error)")
                        return
                    }
                    guard let videoUrlString = videoUrl?.absoluteString else { return }
                    onCompletion(videoUrlString)
                }
            }
        } catch {
            print("DEBUG: Faile upload Video function")
        }
    }

    func uploadImagesToStorage(images: [UIImage], onCompletion: @escaping( ([String]) -> () )) {
        var imageUrlStrings: [String] = []

        guard let userId = auth.currentUser?.uid else { return }

        for image in images {
            let imageId: String = UUID().uuidString
            guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
            let refStorage = storage.reference(withPath: userId + "/" + imageId)

            refStorage.putData(imageData, metadata: nil) { storageMetaData, error in
                if let error = error{
                    print("DEBUG: Error while uploading Photo \(error)")
                    return
                }

                refStorage.downloadURL { imageUrl, error in
                    if let error = error{
                        print("DEBUG: Error while downloading Photo \(error)")
                        return
                    }

                    guard let imageUrlString = imageUrl?.absoluteString else { return }
                    imageUrlStrings.append(imageUrlString)
                    onCompletion(imageUrlStrings)
                }
            }
        }
    }
}

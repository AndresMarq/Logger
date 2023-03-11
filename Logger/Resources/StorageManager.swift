//
//  StorageManager.swift
//  Logger
//
//  Created by Andres Marquez on 2023-03-10.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    // Internal storage reference to Firebase Storage
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    //  Uploads picture to firebase storage and returns completion with url string to donwload
    public func uploadProfilePicture(with data: Data, filename: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(filename)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                print("Failed to upload data to firebase for picture: \(error!.localizedDescription)")
                completion(.failure(StorageErros.failedToUpload))
                return
            }
            
            self?.storage.child("images/\(filename)").downloadURL(completion: { url, error in
                guard let url = url else {
                    completion(.failure(StorageErros.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErros: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErros.failedToGetDownloadUrl))
                return
            }
            
            completion(.success(url))
        })
    }
}

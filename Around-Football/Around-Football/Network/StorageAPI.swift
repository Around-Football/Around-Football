//
//  StorageAPI.swift
//  Around-Football
//
//  Created by 진태영 on 11/15/23.
//

import UIKit

import FirebaseStorage
import Kingfisher

struct StorageAPI {

    static func uploadImage(image: UIImage, id: String, completion: @escaping(URL?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.4) else { return completion(nil) }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let imageReference = Storage.storage().reference().child("\(id)/\(imageName)")
        imageReference.putData(data, metadata: metaData) { _, _ in
            imageReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    static func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                let image = value.image
                completion(image)
            case .failure(let error):
                print("DEBUG - Error retrieving image from cache: \(error.localizedDescription)")
                let tempImage = UIImage(named: "TempImageMessage")
                completion(tempImage)
            }
        }
    }
}

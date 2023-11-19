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
    public typealias ImageResource = KF.ImageResource

    static func uploadImage(image: UIImage, channel: Channel, completion: @escaping(URL?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.4) else { return completion(nil) }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let imageReference = Storage.storage().reference().child("\(channel.id)/\(imageName)")
        imageReference.putData(data, metadata: metaData) { _, _ in
            imageReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    static func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: url.absoluteString)
        storageRef.downloadURL { url, error in
            if let error = error {
                //Handle Error
                print("Error getting download URL: \(error.localizedDescription)")
            } else if let url = url {
                let resource = ImageResource(downloadURL: url)
                let cache = ImageCache.default
                cache.retrieveImage(forKey: resource.cacheKey, options: .none) { result in
                    switch result {
                    case .success(let value):
                        if let image = value.image {
                            // 이미지 캐시
                            completion(image)
                        } else {
                            // 이미지가 캐시에 없으므로 다운로드합니다.
                            KingfisherManager.shared.retrieveImage(with: resource) { result in
                                switch result {
                                case .success(let value):
                                    // 이미지 다운로드에 성공했습니다.
                                    completion(value.image)
                                case .failure(let error):
                                    // 이미지 다운로드에 실패했습니다.
                                    print("Error retrieving image from cache: \(error.localizedDescription)")
                                }
                            }

                        }
                    case .failure(let error):
                        print("Error retrieving image from cache: \(error.localizedDescription)")
                    }
                }
            }
        }
        
    }
}

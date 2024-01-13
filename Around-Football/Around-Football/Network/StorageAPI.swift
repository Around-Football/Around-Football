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
    
    static func uploadRecruitImage(images: [UIImage?], completion: @escaping(URL?) -> Void) {
        for image in images {
            guard 
                let image = image,
                let data = image.jpegData(compressionQuality: 0.4)
            else {
                return completion(nil)
            }
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
            let imageReference = Storage.storage().reference().child("\(imageName)")
            imageReference.putData(data, metadata: metaData) { _, _ in
                imageReference.downloadURL { url, _ in
                    completion(url)
                }
            }
        }
    }
    
//    static func uploadProfileImage(image: UIImage, id: String, completion: @escaping(URL?) -> Void) {
//        guard let data = image.jpegData(compressionQuality: 0.4) else { return completion(nil) }
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpeg"
//
//        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
//        let imageReference = Storage.storage().reference().child("userProfile/\(id)/\(imageName)")
//        
//        let userStorageRef = Storage.storage().reference().child("userProfile/\(id)")
//        userStorageRef.delete { error in
//            if let error = error {
//                print("스토리지 삭제 에러. \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//        }
//        
//        //새로 이미지 올리기
//        imageReference.putData(data, metadata: metaData) { _, _ in
//            imageReference.downloadURL { url, _ in
//                completion(url)
//            }
//        }
//    }
    
    static func uploadProfileImage(image: UIImage, id: String, completion: @escaping (URL?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.4) else { return completion(nil) }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        // 새로운 이미지 업로드
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let imageReference = Storage.storage().reference().child("userProfile/\(id)/\(imageName)")

        // 기존 이미지 폴더 삭제
        let userStorageRef = Storage.storage().reference().child("userProfile/\(id)")
        userStorageRef.listAll { result, error in
            if let error = error {
                print("이전 이미지 폴더 리스트 가져오기 에러: \(error.localizedDescription)")
                completion(nil)
                return
            }

            let deleteGroup = DispatchGroup()

            for item in result!.items {
                deleteGroup.enter()
                item.delete { error in
                    if let error = error {
                        print("이전 이미지 삭제 에러: \(error.localizedDescription)")
                    }
                    deleteGroup.leave()
                }
            }

            deleteGroup.notify(queue: .main) {
                // 기존 이미지 폴더 삭제 후, 새로운 이미지 업로드
                imageReference.putData(data, metadata: metaData) { _, error in
                    if let error = error {
                        print("이미지 업로드 에러. \(error.localizedDescription)")
                        completion(nil)
                        return
                    }

                    // 이미지 업로드 성공 후, 다운로드 URL 얻기
                    imageReference.downloadURL { url, _ in
                        completion(url)
                    }
                }
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

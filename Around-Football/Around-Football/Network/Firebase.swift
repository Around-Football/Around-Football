//
//  Firebase.swift
//  Around-Football
//
//  Created by 진태영 on 10/11/23.
//

import Foundation

import FirebaseFirestore

struct FirebaseAPI {
    static let shared = FirebaseAPI()
    
    func fetchFields(completion: @escaping(([Field]) -> Void)) {
        REF_FIELD.getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                let errorMessage = error?.localizedDescription ?? "None ERROR"
                print("DEBUG: fetchFields Error - \(errorMessage)")
                return
            }
            
            let documentsData = snapshot.documents.map { $0.data() }
            
            completion(Field.convertToArray(documents: documentsData))
        }
    }
    
    func fetchMockFieldsData(completion: @escaping(([Field]) -> Void)) {
        let fileName: String = "FieldMock"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(
            forResource: fileName,
            withExtension: extensionType
        ) else {
            print("파일 위치 없음")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let decoder = JSONDecoder()
            let fields = try decoder.decode([Field].self, from: data)
            completion(fields)
        } catch {
            print("json load fail")
        }
    }
    
    func fetchRecruitFieldData(
        fieldID: String,
        date: Date,
        completion: @escaping(([Recruit]) -> Void)
    ) {
        REF_RECRUIT
            .whereField("fieldID", isEqualTo: fieldID)
            .whereField("matchDate", isEqualTo: date)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    let errorMessage = error?.localizedDescription ?? "None ERROR"
                    print("DEBUG: fetchRecruitFieldData Error - \(errorMessage)")
                    return
                }
                
                let documentsData = snapshot.documents.map { $0.data() }
                
            }
    }
}

func saveFieldJsonData<T: Encodable>(data:T) {
    let jsonEncoder = JSONEncoder()
    
    do {
        let encodedData = try jsonEncoder.encode(data)
        print(String(data: encodedData, encoding: .utf8)!)
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectoryUrl.appendingPathComponent("FieldMock.json")
        print("DEBUG: FILEURL - \(fileURL.description)")
        
        do {
            try encodedData.write(to: fileURL)
            
            print("Save File")
        }
        catch let error as NSError {
            print(error)
        }
        
        
    } catch {
        print(error)
    }
    
}

//
//  ImageHelper.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import FirebaseStorage
import Foundation

struct ImageHelper {
    func createAndThrowURL(fileName: String,data: Data,completion: @escaping (String?) -> Void)  {
        let pathName = "\(UUID().uuidString)/\(fileName).jpg"
        let imageRef = Storage.storage().reference().child(pathName)
        imageRef.putData(data, metadata: nil) { _, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                completion(nil)
            } else {
                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("URL alınırken hata oluştu: \(error.localizedDescription)")
                        completion(nil)
                    } else if let downloadURL = url {
                        completion(downloadURL.absoluteString)
                    }
                }
            }
        }
    }
}

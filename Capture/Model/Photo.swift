//
//  Photo.swift
//  Capture
//
//  Created by Douglas Fuller on 28/08/2022.
//

import Foundation
 
struct Photo {
    
    var imageData: Data?
    let farm: Int
    let height_m: Int
    let id: String
    let isfamily: Bool?
    let isfriend: Bool?
    let ispublic: Bool?
    let owner: String
    let secret: String
    let server: String
    let title: String
    let url_m: String
    let width_m: Int
    
    init(_ dictionary: [String: AnyObject]) {
        self.farm = dictionary["farm"] as? Int ?? 0
        self.height_m = dictionary["height_m"] as? Int ?? 0
        self.id = dictionary["id"] as? String ?? ""
        self.isfamily = dictionary["isfamily"] as? Bool
        self.isfriend = dictionary["isfriend"] as? Bool
        self.ispublic = dictionary["ispublic"] as? Bool
        self.owner = dictionary["owner"] as? String ?? ""
        self.secret = dictionary["secret"] as? String ?? ""
        self.server = dictionary["server"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.url_m = dictionary["url_m"] as? String ?? ""
        self.width_m = dictionary["width_m"] as? Int ?? 0
    }
        
    static func photosFromResults(_ results: [[String:AnyObject]]) -> [Photo] {        
        var photos = [Photo]()
        
        for result in results {
            photos.append(Photo(result))
        }
        return photos
    }
}



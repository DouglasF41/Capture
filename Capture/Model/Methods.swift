//
//  Methods.swift
//  Capture
//
//  Created by Douglas Fuller on 28/08/2022.
//

import Foundation
import UIKit

extension Client {
    
    func getLocationPhotos(_completionHandlerForPhotos: @escaping (_ result: [String]?, _ error: NSError?) -> Void) {
        
        let randomPage = Int(arc4random_uniform(UInt32(40))) + 1
        
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.Page:randomPage,
            Constants.FlickrParameterKeys.PerPage:12,
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ] as [String : Any]
        
        
        let _: String = Constants.Flickr.APIScheme + Constants.Flickr.APIHost + Constants.Flickr.APIPath
        
        /* Make request */
        _ = taskForGETPhotos(parameters: methodParameters as [String : AnyObject]) { (results, error) in
            
            /* Send data to the completion handler */
            if let error = error {
                
                _completionHandlerForPhotos(nil, error)
                
            } else {
                
                /* GUARD: Is the "photos" key in our result? */
                if let results = results as? [String:Any] {
                    
                    /* GUARD: Is the "photo" key in photosDictionary? */
                    guard let photosArray = results[Constants.FlickrResponseKeys.Photos] as? [String: Any] else {
                        print("Cannot find key '\(Constants.FlickrResponseKeys.Photo)' in \(results)")
                        return
                    }
                    
                    guard let photo = photosArray["photo"] as? [[String : Any]] else {
                        
                        print("array paring failure")
                        return
                        
                    }
                    
                    if photo.count == 0 {
                        let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                        _completionHandlerForPhotos(nil, statusCodeError)
                        return
                    }
                    
                    var imagesString: [String] = []
                    
                    for i in 0...photo.count - 1 {
                        let photoDictionary = photo[i] as [String: Any]
                        let imgURL = photoDictionary["url_m"] as! String
                        imagesString.append(imgURL)
                    }
                    _completionHandlerForPhotos(imagesString, nil)
                    
                } else {
                    
                    
                    _completionHandlerForPhotos(nil, NSError(domain: "getLocationPhotos parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getLocationPhotos"]))
                    
                }
            }            
        }
    }
    
    
    func downloadImage(url: String,
                       completion: @escaping (_ data: Data?,_ error: Error?) -> Void) {
        
        let request = URLRequest(url: URL(string: url)!)
        
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error == nil {
                if let data = data {
                    print("Got data!")
                    completion(data,nil)
                }
                
            }else {
                completion(nil,error?.localizedDescription as? Error)
                print(error!)
            }
        }
        dataTask.resume()
    }
}

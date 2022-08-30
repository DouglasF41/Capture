//
//  Methods.swift
//  Capture
//
//  Created by Douglas Fuller on 28/08/2022.
//

import Foundation

extension Client {
    
    func fetchPhotos(_completionHandlerForPhotos: @escaping (_ result: [Photo]?,
                                                             _ error: NSError?) -> Void) {
        let randomPage = Int(arc4random_uniform(UInt32(40))) + 1
        
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.Page:randomPage,
            Constants.FlickrParameterKeys.PerPage:12,
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ] as [String : Any]
        
        let _: String = Constants.Flickr.APIScheme + Constants.Flickr.APIHost + Constants.Flickr.APIPath
        
        /* Make request */
        _ = taskForFetchingPhotos(parameters: methodParameters as [String : AnyObject]) { (results, error) in
            
            /* Send data to the completion handler */
            if let error = error {
                _completionHandlerForPhotos(nil, error)
            } else {
                if let results = results as? [String: Any] {
                    
                    /* GUARD: Is the "photo" key in photosDictionary? */
                    guard let photosArray = results[Constants.FlickrResponseKeys.Photos] as? [String: Any] else {
                        print("Cannot find key '\(Constants.FlickrResponseKeys.Photo)' in \(results)")
                        return
                    }
                    guard let photo = photosArray["photo"] as? [[String : AnyObject]] else {
                        print("array parsing failure")
                        return
                    }
                    
                    if photo.count == 0 {
                        let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                        _completionHandlerForPhotos(nil, statusCodeError)
                        return
                    }
                    let photosFromResults = Photo.photosFromResults(photo)
                    print(photosFromResults)
                    _completionHandlerForPhotos(photosFromResults, nil)
                } else {
                    _completionHandlerForPhotos(nil, NSError(domain: "fetchPhotos parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse fetchPhotos"]))
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
                    completion(data, nil)
                }
            } else {
                completion(nil, error?.localizedDescription as? Error)
                print(error!)
            }
        }
        dataTask.resume()
    }
}

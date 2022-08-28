//
//  PhotoListViewController.swift
//  Capture
//
//  Created by Helen Whittam on 28/08/2022.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
var pictures: [Photo] = [Photo]()
var photoURLs:[String] = [String]()
var picture: Photo!
var photosArray = [Photo]()
    
    @IBOutlet weak var photoList: UITableView!
    

    private func loadPictures() {
       // fetchRequest.sortDescriptors = []

            print("no photos")
            Client.sharedInstance().getLocationPhotos{ (photoURLs, error) in
                if let photoURLs = photoURLs {
                    self.photoURLs = photoURLs
                    for item in photoURLs{
                        performUIUpdatesOnMain {
                            let picture = Photo(context: self.coreDataStack.viewContext)
                            picture.imageURL = item
                            picture.pin = self.pin
                            self.photosArray.append(picture)
                            try? self.coreDataStack.viewContext.save()
                            self.photoAlbum.reloadData()
                            print("Downloaded")
                        }
                    }
                    
                    
                } else {
                    print(error ?? "empty error")
                }
            }
            
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPictures()
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
        let photo = photosArray[(indexPath as NSIndexPath).row]
        
        // Set the image!
        cell.photoImageView.image = UIImage()
        if let data = photo.imageData {
            cell.photoImageView.image =  UIImage(data: data)
        } else {
            Client.sharedInstance().downloadImage(url: photo.imageURL ?? "oops") { (data, error) in
                if let error = error {
                    
                    print(error)
                } else{
                    performUIUpdatesOnMain {
                        cell.photoImageView.image =  UIImage(data: data!)
                        photo.imageData = data
                        try?  self.coreDataStack.viewContext.save()
                    }
                }
            }
        }
        
        return cell
    }
    
    
    
    
    
//    @IBAction func newCollection(_ sender: Any) {
//
//
//        let albumToDelete = fetchedResultsController.fetchedObjects
//        for photo in albumToDelete!{
//            coreDataStack.viewContext.delete(photo)
//        }
//        try? coreDataStack.viewContext.save()
//
//        reloadPictures()
//    }

}

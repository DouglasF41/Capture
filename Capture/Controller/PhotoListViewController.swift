//
//  PhotoListViewController.swift
//  Capture
//
//  Created by Douglas Fuller on 28/08/2022.
//

import UIKit

class PhotoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var photoList: UITableView!
    
    private var photosArray = [Photo]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photosArray[(indexPath as NSIndexPath).row]
        
        let controller = (storyboard?.instantiateViewController(withIdentifier: "Detail") as? DescriptionViewControlller)!
        controller.imageURL = photo.url_m
        controller.photoDescription = photo.title
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    private func loadPictures() {
        Client.sharedInstance().fetchPhotos{ (photos, error) in
            if let photos = photos {
                self.photosArray = photos
             //   var imageDataArray = [Data]()
                for photo in photos {
                    Client.sharedInstance().downloadImage(url: photo.url_m, photo: photo) { data, error in
                        if let error = error {
                            print(error)
                        } else {
                            var photo = photo
                            DispatchQueue.main.async {
                                if let data = data {
                                    photo.imageData = data
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    
                    print("Downloaded")
                    self.photoList.delegate = self
                    self.photoList.dataSource = self
                    sleep(3)
                    self.photoList.reloadData()
                }                
            } else {
                print(error ?? "empty error")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoList.rowHeight = 145
        loadPictures()
    }
}

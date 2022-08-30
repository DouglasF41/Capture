//
//  PhotoTableViewCell.swift
//  Capture
//
//  Created by Douglas Fuller on 28/08/2022.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!

    override func prepareForReuse() {
        photoImageView.image = nil
    }
}





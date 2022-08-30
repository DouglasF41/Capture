//
//  DescriptionViewControlller.swift
//  Capture
//
//  Created by Douglas Fuller on 30/08/2022.
//

import UIKit

class DescriptionViewControlller: UIViewController {
    var imageURL: String!
    var photoDescription: String!
    
    @IBOutlet private weak var imageview: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageString = URL(string: imageURL)
        if let imageData = try? Data(contentsOf: imageString!) {
            imageview.image = UIImage(data: imageData)
        }
        textView.text = "'" + photoDescription + "'"
    }
}

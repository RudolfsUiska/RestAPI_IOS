//
//  PhotoViewerController.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 16/04/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit
var photoViewerURL: URL?
class PhotoViewerController: UIViewController {
    @IBOutlet weak var photoViewer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("te jābut istajam linkam ",photoViewerURL!)
        let fileName = photoViewerURL?.lastPathComponent
        

        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent(fileName ?? "dog-12.jpg")
        let newImage = UIImage(contentsOfFile: imageURL.path)!
        print(imageURL)
        DispatchQueue.main.async {
           self.photoViewer.image = newImage
            
        }
        
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

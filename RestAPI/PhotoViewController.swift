//
//  PhotoViewController.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 22/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit
class PhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    

    @IBOutlet weak var collectionView: UICollectionView!

    var photos = [FilesJson]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotos()

    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func fetchPhotos() -> Void{
        let url = URL(string: "https://api.github.com/repos/RudolfsUiska/FilesForRestAPI/contents/photos")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data, error == nil, response != nil else { print("error")
                return
                
            }
            print("Downoladed")
            print(data)
            do
            {
                let decoder = JSONDecoder()
                let downloadedDocs = try decoder.decode([FilesJson].self, from: data)
                self.photos = downloadedDocs
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    //self.tableView.reloadData()
                }
                
            } catch {
                print("error after downloading")
            }
        }
        task.resume()
    }
    


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath as IndexPath) as! PhotoCollectionCell
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        var p = true
        if p {
            
        p = false
        if let dirPath = paths.first
        {
            let name = photos[indexPath.row].name
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
            cell.imageView.image = UIImage(contentsOfFile: imageURL.path)
            
           download(fileName: photos[indexPath.row].name, fileUrlString: photos[indexPath.row].download_url)
            
        
        }
        }
                return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("preesed")
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
       
        
        if let dirPath = paths.first
        {
            let name = photos[indexPath.row].name
            let photoURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
            photoViewerURL = photoURL
            
        }
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PhotoViewerID") as! PhotoViewerController
        self.present(next, animated: true, completion: nil)
}
    func transition() {

    }
    func download(fileName: String, fileUrlString: String) {
        let fileURL = URL(string: fileUrlString)
        // Create destination URL
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy/MM/dd/ HH:mm:ss"
        let dateString = formatter.string(from: now)
        
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)
        // print("Files will be downloaded at: \(destinationFileUrl)")
        
        //Create URL to the source file you want to download
        
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded \(fileName). \(dateString)  Status code: \(statusCode)")
                    
                    
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    self.collectionView.reloadData()
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "");
            }
        }
        
        
        task.resume()
    }
}

//
//  Downloader.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 22/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit


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
            } catch (let writeError) {
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
            }
            
        } else {
            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "");
        }
    }
    task.resume()
}

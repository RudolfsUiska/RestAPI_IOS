//
//  ViewController.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 20/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit
struct GitHubContent {
    let name: String?
    let company: String?
    let bio: String?
    let imageUrl: String?
}
class ViewController: UIViewController {
    @IBOutlet weak var bio_label: UILabel!
    @IBOutlet weak var company_label: UILabel!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var image_view: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        
    }
    func fetchUserData() -> Void{
        let url = URL(string: "https://api.github.com/users/RudolfsUiska")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let data = data {
                do{
                    let jsonSerialized = try
                        JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let validDictionary = jsonSerialized{
                        let validName = validDictionary["name"] as? String
                        let validCopmany = validDictionary["company"] as? String
                        let validBio = validDictionary["bio"] as? String
                        let validImageURL = validDictionary["avatar_url"] as? String
                        DispatchQueue.main.async {
                            self.name_label.text = validName ?? "No name received"
                            self.company_label.text = validCopmany ?? "No company name received"
                            self.bio_label.text = validBio ?? "no bio received"
                            self.image_view.downloaded(from: validImageURL ?? "https://dummyimage.com/400x400/000/fff&text=No+picture+")
                        }
                    }
                } catch let error as NSError{
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

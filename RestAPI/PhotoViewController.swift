//
//  PhotoViewController.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 22/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit
import Alamofire
class PhotoViewController: UIViewController, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var photos = [FilesJson]()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPhotos()
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
                    self.tableView.reloadData()
                }
                
            } catch {
                print("error after downloading")
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as? PhotoCell else { return UITableViewCell() }
        cell.nameLbl.text = photos[indexPath.row].name
        cell.typeLbl.text = photos[indexPath.row].type
        let sizeMB = photos[indexPath.row].size / 1024
        cell.sizeLbl.text = String(sizeMB) + " KB"
        cell.dlBtn.tag = indexPath.row
        //cell.dlBtn.addTarget(self, action: Selector(("dlBtnPressedInside")), for: .touchUpInside)
        //print(cell.dlBtn.tag)
        return cell
    }
    @IBAction func viewBtnPressedInside(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        UIApplication.shared.open(URL(string: photos[indexPath.row].download_url)!)
    }
    
    @IBAction func dlBtnPressedInside(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
       // print("row is = \(indexPath.row) && section is = \(indexPath.section)")
       // print(photos[indexPath.row].name)
        download(fileName: photos[indexPath.row].name, fileUrlString: photos[indexPath.row].download_url)
    }

}

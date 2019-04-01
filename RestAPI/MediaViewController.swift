//
//  MediaViewController.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 22/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit
import AVFoundation

class MediaViewController: UIViewController, UITableViewDataSource  {
    var media = [FilesJson]()
    var player = AVPlayer()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

       fetchMedia()
    }
    func fetchMedia() -> Void{
        let url = URL(string: "https://api.github.com/repos/RudolfsUiska/FilesForRestAPI/contents/media")
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
                self.media = downloadedDocs
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
        return media.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell") as? MediaCell else { return UITableViewCell() }
        cell.nameLbl.text = media[indexPath.row].name
        cell.typeLbl.text = media[indexPath.row].type
        let sizeMB = media[indexPath.row].size / 1024
        cell.sizeLbl.text = String(sizeMB) + " KB"
        cell.dlBtn.tag = indexPath.row
        cell.playBtn.tag = indexPath.row
        //cell.mp3url = media[indexPath.row].download_url
        //cell.sizeLbl.text = String(documents[indexPath.row].size)
        // cell.dlBtn
        return cell
    }

    @IBAction func playBtnPressedInside(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        if let url = URL(string: media[indexPath.row].download_url){
            player = AVPlayer(url: url)
            player.volume = 1.0
            player.play()
        }
        
    }
    @IBAction func dlBtnPressedInside(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        // print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        // print(photos[indexPath.row].name)
        download(fileName: media[indexPath.row].name, fileUrlString: media[indexPath.row].download_url)
    }
}

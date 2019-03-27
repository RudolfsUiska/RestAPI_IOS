//
//  WebViewController.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 22/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UITableViewDataSource  {
    var web = [FilesJson]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeb()
     
    }
    func fetchWeb() -> Void{
        let url = URL(string: "https://api.github.com/repos/RudolfsUiska/FilesForRestAPI/contents/web_pages")
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
                self.web = downloadedDocs
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
        return web.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WebCell") as? WebCell else { return UITableViewCell() }
        cell.nameLbl.text = web[indexPath.row].name
        cell.typeLbl.text = web[indexPath.row].type
        let sizeMB = web[indexPath.row].size / 1024
        cell.sizeLbl.text = String(sizeMB) + " KB"
        cell.dlBtn.tag = indexPath.row

        return cell
    }

    @IBAction func openBtnPressedInside(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        
        UIApplication.shared.open(URL(string: web[indexPath.row].download_url)!)
    }
    @IBAction func dlBtnPressedInside(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        // print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        download(fileName: web[indexPath.row].name, fileUrlString: web[indexPath.row].download_url)
    }
    

}

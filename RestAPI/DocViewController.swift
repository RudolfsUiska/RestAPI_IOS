//
//  DocViewController.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 20/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit

class DocViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var documents = [FilesJson]()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDocs()
    }

    func fetchDocs() -> Void{
        let url = URL(string: "https://api.github.com/repos/RudolfsUiska/FilesForRestAPI/contents/docs")
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
                self.documents = downloadedDocs
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
        return documents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocCell") as? DocCell else { return UITableViewCell() }
        cell.nameLbl.text = documents[indexPath.row].name
        cell.typeLbl.text = documents[indexPath.row].type
        let sizeMB = documents[indexPath.row].size / 1024
        cell.sizeLbl.text = String(sizeMB) + " KB"
        cell.dlBtn.tag = indexPath.row
        return cell
    }
    
    @IBAction func openBtnPressedInside(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        UIApplication.shared.open(URL(string: documents[indexPath.row].download_url)!)
    }
    
    @IBAction func dlBtnPressedInside(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        // print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        // print(photos[indexPath.row].name)
        download(fileName: documents[indexPath.row].name, fileUrlString: documents[indexPath.row].download_url)
    }
}

//
//  Docs.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 21/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit

struct FilesJson: Codable{
    let name: String
    let path: String
    let sha: String
    let size: Int
    let url: String
    let html_url: String
    let git_url: String
    let download_url: String
    let type: String
    
    struct Links: Codable{
        let selfLink: String
        let gitLink: String
        let htmlLink: String
        private enum CodingKeys : String, CodingKey {
            case selfLink = "self"
            case gitLink = "git"
            case htmlLink = "html"
        }
    }
    let _links: Links
}
//class FilesJson: Codable {
//
//    let name: String
//    let path: String
//    let sha: String
//    let size: String
//    let url: String
//    let html_url: String
//    let git_url: String
//    let download_url: String
//    let type: String
//    let _links: String
//
//
//    init(name: String, path: String, sha: String, size: String,url: String, html_url: String, git_url: String, download_url: String, type: String, _links: String) {
//        self.name = name
//        self.path = path
//        self.sha = sha
//        self.size = size
//        self.url = url
//        self.html_url = html_url
//        self.git_url = git_url
//        self.download_url = download_url
//        self.type = type
//        self._links = _links
//
//    }
//}

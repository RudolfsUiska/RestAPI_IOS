//
//  TableViewCell.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 21/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit

class DocCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var openBtn: UIButton!
    
    @IBOutlet weak var dlBtn: UIButton!
    @IBOutlet weak var sizeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

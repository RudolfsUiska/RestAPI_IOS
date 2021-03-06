//
//  MediaCell.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 24/03/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//

import UIKit

class MediaCell: UITableViewCell {
    @IBOutlet weak var dlBtn: UIButton!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

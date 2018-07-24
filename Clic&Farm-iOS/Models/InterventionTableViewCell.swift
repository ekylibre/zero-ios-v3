//
//  InterventionTableViewCell.swift
//  ClickAndFarm-IOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class InterventionTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var cropsLabel: UILabel!
    @IBOutlet weak var infosLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var syncImage: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

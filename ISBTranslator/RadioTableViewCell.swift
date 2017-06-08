//
//  RadioTableViewCell.swift
//  ISBTranslator
//
//  Created by Tuan Nguyen on 5/18/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

class RadioTableViewCell: UITableViewCell {

   
    @IBOutlet weak var imageItemView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  HistoryTableViewCell.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 5/11/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceLanguage: UILabel!
    @IBOutlet weak var targetLanguage: UILabel!
    @IBOutlet weak var selectItem: Checkbox!
    @IBOutlet weak var createDate: UILabel!
    @IBOutlet weak var sourceText: UILabel!
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellHeader: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

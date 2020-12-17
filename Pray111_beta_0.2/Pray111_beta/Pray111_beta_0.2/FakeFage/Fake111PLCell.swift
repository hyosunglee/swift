//
//  Fake111PLCell.swift
//  Pray111_beta_0.2
//
//  Created by vlm on 2020/11/20.
//  Copyright © 2020 vlm. All rights reserved.
//

import Foundation
import UIKit

class Fake111PLCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var DTTM: UILabel!
    @IBOutlet weak var contents: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

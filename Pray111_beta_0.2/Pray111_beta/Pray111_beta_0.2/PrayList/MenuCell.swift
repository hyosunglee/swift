//
//  MenuCell.swift
//  TableView
//
//  Created by vlm on 2020/04/16.
//  Copyright © 2020 vlm. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

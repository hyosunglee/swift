//
//  MyPageCell.swift
//  TableView
//
//  Created by vlm on 2020/10/20.
//  Copyright © 2020 vlm. All rights reserved.
//

import UIKit

class MyPageCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
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

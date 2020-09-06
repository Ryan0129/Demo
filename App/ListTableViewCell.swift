//
//  ListTableViewCell.swift
//  App
//
//  Created by ucom Apple root S08 on 2019/7/24.
//  Copyright © 2019 yan r. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var kindText: UILabel!
    @IBOutlet var moneyText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

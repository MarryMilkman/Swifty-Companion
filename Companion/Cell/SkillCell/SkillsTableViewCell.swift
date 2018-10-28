//
//  SkillsTableViewCell.swift
//  Companion
//
//  Created by Ivan SELETSKYI on 10/17/18.
//  Copyright © 2018 Ivan SELETSKYI. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameSkill: UILabel!
    @IBOutlet weak var valueSkill: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

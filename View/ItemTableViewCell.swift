//
//  ItemTableViewCell.swift
//  TodoApp
//
//  Created by Trần Huy on 8/13/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SwipeCellKit

class ItemTableViewCell: SwipeTableViewCell {
    
    

    
    @IBOutlet weak var lblDue: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var name: String = "" {
        didSet { lblTitle?.text = name }
    }
    
    var date: String = "" {
        didSet { lblDue?.text = date }
    }
    
    var completed: Bool = false {
        didSet { lblStatus?.text = completed ? "✅" : "⭕️" }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle?.text = name
        lblDue?.text = date
        lblStatus?.text = completed ? "✅" : "⭕️"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

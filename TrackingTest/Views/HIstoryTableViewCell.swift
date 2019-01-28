//
//  HIstoryTableViewCell.swift
//  TrackingTest
//
//  Created by fahmex on 28/01/2019.
//  Copyright © 2019 fahmi. All rights reserved.
//

import UIKit

class HIstoryTableViewCell: UITableViewCell {
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

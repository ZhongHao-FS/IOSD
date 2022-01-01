//
//  CustomCell1.swift
//  ZhongHaoCE07
//
//  Created by Hao Zhong on 7/23/21.
//

import UIKit

class CustomCell1: UITableViewCell {

    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var detail1: UILabel!
    @IBOutlet weak var info1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

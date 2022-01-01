//
//  ProPublicaCell.swift
//  ZhongHaoCE05
//
//  Created by Hao Zhong on 7/15/21.
//

import UIKit

class ProPublicaCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var partyState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  IssueTableViewCell.swift
//  Project3-1
//
//  Created by Sung-Jie Hung on 2023/1/23.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    // add a iboutlet of a uitableviewcell
    // https://stackoverflow.com/questions/53669175/how-to-add-a-iboutlet-of-a-uitableviewcell-object-in-swift-4
    @IBOutlet var myOpenIssueTitle: UILabel!
    @IBOutlet var myOpenIssueUser: UILabel!
    @IBOutlet var myClosedIssueTitle: UILabel!
    @IBOutlet var myClosedIssueUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

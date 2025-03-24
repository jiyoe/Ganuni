//
//  GanuniCell.swift
//  ganuni
//
//  Created by jy on 3/11/24.
//

import UIKit

class GanuniCell: UITableViewCell {
    
    static let identifier = "GanuniCell"

    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myPriceLabel: UILabel!
    @IBOutlet weak var myNumLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

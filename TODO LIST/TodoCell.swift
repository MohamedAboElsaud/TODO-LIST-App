//
//  TodoCell.swift
//  TODO LIST
//
//  Created by mohamed ahmed on 28/07/2023.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var tododateLabel: UILabel!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

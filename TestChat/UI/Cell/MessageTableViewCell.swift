//
//  MessageTableViewCell.swift
//  TestChat
//
//  Created by Vladislav Novoseltsev on 29.07.2017.
//  Copyright © 2017 Vladislav Novoseltsev. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var timeMessageLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setType(type:Int )-> Void {
        switch type {
        case 0:
            nameUserLabel.textColor = UIColor.green
            timeMessageLabel.textColor = UIColor.green
            messageLabel.textColor = UIColor.green
            break
        case 1:
            nameUserLabel.textColor = UIColor.black
            timeMessageLabel.textColor = UIColor.black
            messageLabel.textColor = UIColor.black
            nameUserLabel.text = "Я"
            break
        default:
            break
        }
    }

}

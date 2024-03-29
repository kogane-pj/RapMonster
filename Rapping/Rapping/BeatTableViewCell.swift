//
//  BeatTableViewCell.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/09.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

protocol BeatTableViewCellDelegate: class {
    func didTapSelectButton()
}

class BeatTableViewCell: UITableViewCell {

    @IBOutlet weak var beatImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var practiceButton: UIButton!
    
    weak var delegate: BeatTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func didTapSelectButton(sender: AnyObject) {
        self.delegate?.didTapSelectButton()
    }
}

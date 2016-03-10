//
//  RapListTableViewCell.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/18.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class RapListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var playSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func openCellIfNeeded(isOpen:Bool) {
        self.startTime.hidden   = !isOpen
        self.endTime.hidden     = !isOpen
        self.playButton.hidden  = !isOpen
        self.playSlider.hidden  = !isOpen
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width,167)
    }
    
}

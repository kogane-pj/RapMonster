//
//  RapListTableViewCell.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/18.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

protocol RapListTableViewCellDelegate {
    func didTapPlayButton()
}

class RapListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rapTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var playSlider: UISlider!
    
    var delegate:RapListTableViewCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        self.playSlider.setThumbImage(UIImage.init(named:"rectangle199"), forState: .Normal)
        self.playSlider.setThumbImage(UIImage.init(named:"rectangle199"), forState: .Selected)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func openCellIfNeeded(isOpen:Bool) {
        self.startTime.hidden   = !isOpen
        self.endTime.hidden     = !isOpen
        self.playButton.hidden  = !isOpen
        self.playSlider.hidden  = !isOpen
        
        self.rapTitle.textColor  = setTextColor(isOpen)
        self.startTime.textColor = setTextColor(isOpen)
        self.endTime.textColor   = setTextColor(isOpen)
        
        self.contentView.backgroundColor = setTextColor(!isOpen)
       
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width,167)
    }
   
    func setupSeek(rap:Rap) {
        self.startTime.text = AudioManager.sharedInstance.getPlayTimeInfo(rap.path).startTime
        self.endTime.text   = AudioManager.sharedInstance.getPlayTimeInfo(rap.path).endTime
    }
    
    private func setTextColor(isOpen:Bool) -> UIColor {
        return (isOpen) ? UIColor.blackColor() : UIColor.whiteColor()
    }
    
    @IBAction func didTapPlayButton(sender: AnyObject) {
        if self.playButton.selected {
            //TODO:stopボタンがきたらそれを埋め込む
        }
        
        self.delegate.didTapPlayButton()
    }
    
    
}

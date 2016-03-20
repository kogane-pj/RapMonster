//
//  RapListTableViewCell.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/18.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

protocol RapListTableViewCellDelegate: class {
    func didTapPlayButton()
    func didTapShareButton()
}

class RapListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rapTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var separatorView: UIView!
    
    weak var delegate:RapListTableViewCellDelegate?
    
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
        self.startTime.hidden       = !isOpen
        self.endTime.hidden         = !isOpen
        self.playButton.hidden      = !isOpen
        self.playSlider.hidden      = !isOpen
        self.separatorView.hidden   = isOpen
        
        self.rapTitle.textColor  = setTextColor(isOpen)
        self.startTime.textColor = setTextColor(isOpen)
        self.endTime.textColor   = setTextColor(isOpen)
        
        self.contentView.backgroundColor = setTextColor(!isOpen)
       
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width,167)
    }
   
    func setupSeek(rap:Rap) {
        let playTimeInfo = AudioManager.sharedInstance.getPlayEndTimeInfo(rap.path)
        
        updateSeekTime()
        
        self.endTime.text   = playTimeInfo.endTimeString
        self.playSlider.minimumValue = 0
        self.playSlider.maximumValue = playTimeInfo.endTime
    }
    
    private func setTextColor(isOpen:Bool) -> UIColor {
        return (isOpen) ? UIColor.blackColor() : UIColor.whiteColor()
    }
    
    @IBAction func didTapPlayButton(sender: AnyObject) {
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateSeekTime"), userInfo: nil, repeats: true)

        self.delegate?.didTapPlayButton()
    }
    
    func updateSeekTime() {
        self.startTime.text = AudioManager.sharedInstance.getCurretTimeForString()
        self.playSlider.value = AudioManager.sharedInstance.getCurrentTime()
    }
    
    @IBAction func sliderMove(sender: AnyObject) {
        AudioManager.sharedInstance.setCurrentTime(Double(self.playSlider.value))
        self.updateSeekTime()
    }
    
    @IBAction func didTapShareButton(sender: AnyObject) {
       self.delegate?.didTapShareButton()
    }
}

//
//  MyPageViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/18.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController,
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
RapListTableViewCellDelegate,
AdobeUXImageEditorViewControllerDelegate
{
    @IBOutlet weak var recListView: UITableView!
    @IBOutlet weak var iconButton: UIButton!
    
    private var rapArray:[Rap] = []
    private var selectedIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registNib()
        self.setupRapArray()
    }

    func setupRapArray() {
        self.rapArray = RapManager.sharedInstance.allRap
    }

    func registNib() {
        let nib = UINib(nibName: "RapListTableViewCell", bundle: nil)
        self.recListView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        let nib2 = UINib(nibName: "RapListViewSectionCell", bundle: nil)
        self.recListView.registerNib(nib2, forCellReuseIdentifier: "sectionCell")
    }
   
    private func updateIconImage(image:UIImage) {
        image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.iconButton.setImage(image, forState: .Normal)
        self.iconButton.setImage(image, forState: .Selected)
        self.iconButton.setBackgroundImage(image, forState: .Normal)
        self.iconButton.setBackgroundImage(image, forState: .Selected)
        self.iconButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        // TODO:Userクラスに保存
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rapArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.recListView.dequeueReusableCellWithIdentifier("Cell") as! RapListTableViewCell
        
        cell.delegate = self
        let rap = RapManager.sharedInstance.allRap[indexPath.row]
      
        cell.openCellIfNeeded(self.selectedIndexPath == indexPath)
        
        return cell
    }
  
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.recListView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if self.selectedIndexPath == indexPath {
            self.selectedIndexPath = nil //TODO:定数化
            self.recListView.reloadData()
            return
        }
        
        self.selectedIndexPath = indexPath
        
        let cell = self.recListView.cellForRowAtIndexPath(indexPath) as! RapListTableViewCell
        let rap = RapManager.sharedInstance.allRap[indexPath.row]
        
        cell.openCellIfNeeded(true)
        cell.setupSeek(rap)
       
        self.recListView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.selectedIndexPath == indexPath {
            return 167
        }
        
        return 110;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.recListView.dequeueReusableCellWithIdentifier("sectionCell") as! RapListViewSectionCell
    }
  
    //MARK: didTap delegate
    
    @IBAction func didTapIconButton(sender: AnyObject) {
        selectedPhotoAlert()
    }
    
    func selectedPhotoAlert() {
        let actionSheet:UIAlertController = UIAlertController(title:"",
            message: "アイコンに使用する画像を選択してください",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
        })
        
        let defaultAction:UIAlertAction = UIAlertAction(title: "写真を撮る",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                //TODO: 循環参照のfix
                PictureUtil.pickImageFromCamera(self, vc: self)
        })
        
        let destructiveAction:UIAlertAction = UIAlertAction(title: "ライブラリから選択",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                //TODO: 循環参照のfix
                PictureUtil.pickImageFromLibrary(self, vc: self)
        })
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(defaultAction)
        actionSheet.addAction(destructiveAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: AdobeUXImageEditorViewControllerDelegate
    
    func photoEditor(editor: AdobeUXImageEditorViewController, finishedWithImage image: UIImage?) {
        editor.dismissViewControllerAnimated(true, completion: nil)
    
        if let _image = image {
            updateIconImage(_image)
        } else {
            print("error")
        }
    }
   
    func photoEditorCanceled(editor: AdobeUXImageEditorViewController) {
        editor.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            let adobeViewCtr = AdobeUXImageEditorViewController(image: image)
            adobeViewCtr.delegate = self
            
            picker.dismissViewControllerAnimated(true, completion:{
                // TODO:循環参照を解消する
                self.presentViewController(adobeViewCtr, animated: true, completion: nil)
            });
            return
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
   
    //MARK: RapListTableViewCell Delegate
    
    func didTapPlayButton() {
        guard let row = self.selectedIndexPath?.row else{
            //TODO:Alert
            return
        }
       
        if AudioManager.sharedInstance.isPlaying() {
            AudioManager.sharedInstance.stop()
            return
            //TODO:stopボタンがきたらそれを埋め込む
        }
        
        let path = RapManager.sharedInstance.allRap[row].path
        AudioManager.sharedInstance.playRap(path)
    }
    
    func didTapShareButton() {
        ActivityController().showActivityView(self)
    }
    
    //MARK : TableView in ScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // TODO:スクロールにあわせてtableViewの位置をずらす
    }
}

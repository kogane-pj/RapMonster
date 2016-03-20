//
//  MyPageViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/18.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
AdobeUXImageEditorViewControllerDelegate
{
    @IBOutlet weak var iconButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
   
    private func selectedPhotoAlert() {
        weak var vc = self
        
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
                PictureUtil.pickImageFromCamera(vc!, vc: vc!)
        })
        
        let destructiveAction:UIAlertAction = UIAlertAction(title: "ライブラリから選択",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                //TODO: 循環参照のfix
                PictureUtil.pickImageFromLibrary(vc!, vc: vc!)
        })
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(defaultAction)
        actionSheet.addAction(destructiveAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: didTap delegate
    
    @IBAction func didTapIconButton(sender: AnyObject) {
        selectedPhotoAlert()
    }
    
    @IBAction func didTapSettingButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showSettingVC" ,sender: nil)
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
           
            weak var vc = self
            picker.dismissViewControllerAnimated(true, completion:{
                // TODO:循環参照を解消する
                vc!.presentViewController(adobeViewCtr, animated: true, completion: nil)
            });
            return
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

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
   
    //MARK: didTap delegate
    
    @IBAction func didTapIconButton(sender: AnyObject) {
        PictureUtil.showSelectedPhotoAlert(self, vc: self)
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

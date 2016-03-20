class PictureUtil: NSObject {
   
    class func showSelectedPhotoAlert(vc:MyPageViewController) {
       
        weak var _vc = vc
        
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
                PictureUtil.pickImageFromCamera(_vc!)
        })
        
        let destructiveAction:UIAlertAction = UIAlertAction(title: "ライブラリから選択",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                PictureUtil.pickImageFromLibrary(_vc!)
        })
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(defaultAction)
        actionSheet.addAction(destructiveAction)
        
        _vc!.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    class func pickImageFromCamera(vc:MyPageViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = vc
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            vc.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    class func pickImageFromLibrary(vc:MyPageViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = vc
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            vc.presentViewController(controller, animated: true, completion: nil)
        }
    }
}

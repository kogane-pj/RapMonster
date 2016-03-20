class PictureUtil: NSObject {
   
    class func showSelectedPhotoAlert(delegate:protocol<UIImagePickerControllerDelegate,UINavigationControllerDelegate>,vc:UIViewController) {
       
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
                PictureUtil.pickImageFromCamera(delegate, vc:_vc!)
        })
        
        let destructiveAction:UIAlertAction = UIAlertAction(title: "ライブラリから選択",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                PictureUtil.pickImageFromLibrary(delegate, vc:_vc!)
        })
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(defaultAction)
        actionSheet.addAction(destructiveAction)
        
        _vc!.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    class func pickImageFromCamera(delegate:protocol<UIImagePickerControllerDelegate,UINavigationControllerDelegate>,vc:UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = delegate
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            vc.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    class func pickImageFromLibrary(delegate:protocol<UIImagePickerControllerDelegate,UINavigationControllerDelegate>,vc:UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = delegate
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            vc.presentViewController(controller, animated: true, completion: nil)
        }
    }
}

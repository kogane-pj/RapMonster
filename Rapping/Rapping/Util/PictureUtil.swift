class PictureUtil: NSObject {
    
    // vc:UIViewController<protocol>ってかけなくなったのだろうか。。
    class func pickImageFromCamera(delegate:protocol<UIImagePickerControllerDelegate,UINavigationControllerDelegate>, vc:UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = delegate
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            vc.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    class func pickImageFromLibrary(delegate:protocol<UIImagePickerControllerDelegate,UINavigationControllerDelegate>, vc:UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = delegate
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            vc.presentViewController(controller, animated: true, completion: nil)
        }
    }
}

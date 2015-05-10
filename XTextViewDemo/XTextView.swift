import UIKit
import AssetsLibrary
import MobileCoreServices
import MessageUI

protocol assistProtocol{
    func insertImage()
}
class XTextView : UITextView,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate{
    var fontSize    = 14
    var controller : UIViewController!
    var container: NSTextContainer!
    var assist: assistProtocol!
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /**
    初始化方法
    
    :param: target
    :param: superViewr
    
    :returns: 
    */
    func initMethod(target: UIViewController) {
        self.controller                            = target
        self.typingAttributes[NSFontAttributeName] = UIFont.systemFontOfSize((CGFloat)(self.fontSize))
    }
    /**
    插入图片
    */
    func insertImage() {
        var sheet:UIActionSheet
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从相册选择", "拍照")
        }else{
            sheet = UIActionSheet(title:nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从相册选择")
        }
        sheet.showInView(self.controller.presentedViewController?.view)

    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if(buttonIndex != 0){
            if(buttonIndex==1){
            sourceType                                        = UIImagePickerControllerSourceType.PhotoLibrary
            }else{
            sourceType                                        = UIImagePickerControllerSourceType.Camera
            }
            let imagePickerController:UIImagePickerController = UIImagePickerController()
            imagePickerController.delegate                    = self
            imagePickerController.allowsEditing               = true
            imagePickerController.sourceType                  = sourceType
            self.controller.presentViewController(imagePickerController, animated: true, completion: {
            })
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        var string                                           = NSMutableAttributedString(attributedString: self.attributedText)
        var img                                              = info[UIImagePickerControllerEditedImage] as! UIImage
        img                                                  = self.scaleImage(img)
        var textAttachment                                   = NSTextAttachment()
        textAttachment.image                                 = img

        var textAttachmentString                             = NSAttributedString(attachment: textAttachment)
        string.appendAttributedString(textAttachmentString)
   //     self.attributedText                                  = string

        var storage                                          = NSTextStorage(attributedString: string)
        var layoutmanage                                     = NSLayoutManager()
        var container                                        = NSTextContainer(size: self.frame.size)
        layoutmanage.addTextContainer(container)
        storage.addLayoutManager(layoutmanage)
        layoutmanage.textStorage                             = storage
        var y                                                = self.contentOffset.y
        self.container = container
        self.assist.insertImage()
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    func scaleImage(image:UIImage)->UIImage{
        UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, image.size.height*(self.bounds.size.width/image.size.width)))
        image.drawInRect(CGRectMake(0, 0, self.bounds.size.width-16, image.size.height*((self.bounds.size.width-16)/image.size.width)))
        var scaledimage                                      = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledimage

    }
    func imagePickerControllerDidCancel(picker:UIImagePickerController)    {
        self.controller.dismissViewControllerAnimated(true, completion: nil)
    }
    /**
    调用系统邮件功能，制作长图片发送
    */
    func mail() {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
        var configuredMailComposeViewController              = MailComposeViewController()
        if canSendMail() {
            self.controller.presentViewController(configuredMailComposeViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }
    func MailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC                                   = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate                   = self
        mailComposerVC.setToRecipients(nil)
        mailComposerVC.setSubject(nil)
        mailComposerVC.setMessageBody(self.text, isHTML: false)
        var addPic                                           = self.madelongPicture()
        var imageData                                        = UIImagePNGRepresentation(addPic)
        mailComposerVC.addAttachmentData(imageData, mimeType: "", fileName: "longPicture.png")
        return mailComposerVC
    }

    /**
    制作长图片

    :returns: 返回长图片
    */
    func madelongPicture() -> UIImage {

        var image : UIImage!
        UIGraphicsBeginImageContext(self.contentSize)
        var savedContentOffset                                   = self.contentOffset
        var savedFrame                                           = self.frame
        self.contentOffset                                       = CGPointZero
        self.frame                                               = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        image                                                    = UIGraphicsGetImageFromCurrentImageContext()
        self.contentOffset                                       = savedContentOffset
        self.frame                                               = savedFrame
        UIGraphicsEndPDFContext()
        return image
    }
    /**
    邮件发送

    :returns:
    */
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert                                   = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    /**
    添加斜体
    */
    func Obliqueness() {
        var value                                                = self.typingAttributes[NSObliquenessAttributeName] as? NSNumber
        if value == 0 || value == nil{
        self.typingAttributes[NSObliquenessAttributeName]        = 0.5
        }else {
        self.typingAttributes[NSObliquenessAttributeName]        = 0
        }
    }
    /**
    下划线
    */
    func underline() {
        var value                                                = self.typingAttributes[NSUnderlineStyleAttributeName] as? NSNumber
        if value == 0 || value == nil {
        self.typingAttributes[NSUnderlineStyleAttributeName]     = 1
        }else{
        self.typingAttributes[NSUnderlineStyleAttributeName]     = 0
        }
    }
    /**
    设置下划线颜色
    */
    func underlineColor(color: UIColor) {
        self.typingAttributes[NSUnderlineColorAttributeName]     = color
    }
    /**
    字体增大
    */
    func fontincrease() {
        self.fontSize                                            += 2
        self.typingAttributes[NSFontAttributeName]               = UIFont.systemFontOfSize((CGFloat)(self.fontSize))
    }
    /**
    字体减小
    */
    func fontdecrease() {
        self.fontSize                                            -= 2
        self.typingAttributes[NSFontAttributeName]               = UIFont.systemFontOfSize((CGFloat)(self.fontSize))
    }
    /**
    添加删除线
    */
    func strikethrough() {
        var value                                                = self.typingAttributes[NSUnderlineStyleAttributeName] as? NSNumber
        if value == 0 || value == nil {
        self.typingAttributes[NSStrikethroughStyleAttributeName] = 1
        }else{
        self.typingAttributes[NSStrikethroughStyleAttributeName] = 0
        }
    }
    /**
    *  设置删除线颜色
    */
    func strikethroughcolor(color: UIColor) {
        self.typingAttributes[NSStrikethroughColorAttributeName] = color
    }



}
import UIKit

class ViewController: UIViewController,assistProtocol {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var textview: XTextView!
    @IBOutlet weak var aaa: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        var storage                                          = NSTextStorage(attributedString: NSAttributedString(string: ""))
        var layoutmanage                                     = NSLayoutManager()
        var container                                        = NSTextContainer(size: self.textview.frame.size)
        layoutmanage.addTextContainer(container)
        storage.addLayoutManager(layoutmanage)
        self.textview = XTextView(frame: self.textview.frame, textContainer: container)
        self.view.addSubview(self.textview)
        self.textview.assist=self
        self.textview.initMethod(self)
        self.view.addSubview(self.menuView)
    }
    @IBAction func insetImage(sender: AnyObject) {
        self.textview.insertImage()
    }
    @IBAction func Obliqueness(sender: AnyObject) {
        self.textview.Obliqueness()
    }
    @IBAction func underline(sender: AnyObject) {
        self.textview.underline()
    }
    @IBAction func increase(sender: AnyObject) {
        self.textview.fontincrease()
    }
    @IBAction func decrease(sender: AnyObject) {
        self.textview.fontdecrease()
    }
    @IBAction func mail(sender: AnyObject) {
        self.textview.mail()
    }
    @IBAction func share(sender: AnyObject) {
    }
    func insertImage() {
        var y = self.textview.contentOffset.y
        var assistclass = XTextView(frame: self.textview.frame, textContainer: self.textview.container)
        self.view.addSubview(assistclass)
        self.textview=assistclass
        self.textview.assist=self
        self.textview.initMethod(self)
        self.textview.setContentOffset(CGPointMake(0, y+self.view.bounds.width), animated: true)
        self.view.addSubview(self.menuView)
    }
    /**
    注册通知，检测键盘弹出
    
    :param: animated
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleKeyboardDidShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleKeyboardDidHidden"), name:UIKeyboardWillHideNotification, object: nil)
    }

    /**
    检测键盘弹出
    
    :param: paramNotification
    */
    func handleKeyboardDidShow(paramNotification:NSNotification){
        
        
        var userinfo:NSDictionary=(NSDictionary)(dictionary: paramNotification.userInfo!)
        var v:NSValue              = userinfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        var keyboardRect           = v.CGRectValue()
        self.textview.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
            self.aaa.constant  = keyboardRect.size.height
            self.view.layoutIfNeeded()
            }, completion:nil)
    }
    /**
    检测键盘收起
    */
    func handleKeyboardDidHidden(){
        self.textview.contentInset         = UIEdgeInsetsZero
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
            self.aaa.constant          = 0
            }, completion:nil)
    }

}


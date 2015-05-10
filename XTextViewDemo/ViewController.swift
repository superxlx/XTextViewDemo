//
//  ViewController.swift
//  XTextViewDemo
//
//  Created by xlx on 15/5/9.
//  Copyright (c) 2015年 xlx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textview: XTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textview.initMethod(self, superView: self.view)

    }
    @IBAction func insetImage(sender: AnyObject) {
        self.textview.insertImage()
    }
    @IBAction func Obliqueness(sender: AnyObject) {
        self.textview.Obliqueness()
    }
    @IBAction func underline(sender: AnyObject) {
   //     self.textview.underline()
        var value = self.textview.typingAttributes[NSUnderlineStyleAttributeName] as? NSNumber
        if value == 0 || value == nil {
            self.textview.typingAttributes[NSUnderlineStyleAttributeName] = 1
        }else{
            self.textview.typingAttributes[NSUnderlineStyleAttributeName] = 0
        }
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

}


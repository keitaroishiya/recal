//
//  ViewController.swift
//  recal
//
//  Created by K on 2014/12/21.
//  Copyright (c) 2014年 K. All rights reserved.
//

import UIKit
//import QuartzCore

class ViewController: UIViewController {

    @IBOutlet var BtnEasy: UIButton!
    @IBOutlet var BtnNormal: UIButton!

    private var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var bt_back = UIBarButtonItem()
        bt_back.title = ""

        // UIImageViewを作成する.
        // let imgView: UIImageView = UIImageView(frame: CGRectMake(0,0,44,44))

        // 表示する画像を設定する.
        // let img = UIImage(named: "back.png")
        // 画像をUIImageViewに設定し、selfに追加.
        // imgView.image = img
        // bt_back.image = img
        // bt_back.tintColor = Utility.hex("e50012", alpha: 1.0)
        // bt_back.setBackgroundImage(img, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)

        self.navigationItem.backBarButtonItem = bt_back
        self.navigationController?.interactivePopGestureRecognizer.enabled = false


        let bgImgView: UIImageView = UIImageView(frame: CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height))
        let bgImg = UIImage(named: "background_app.jpg")
        bgImgView.image = bgImg
        self.view.addSubview(bgImgView)
        self.view.sendSubviewToBack(bgImgView)

        BtnEasy.addTarget(self, action: "setEasyMode:", forControlEvents: .TouchUpInside)
        BtnNormal.addTarget(self, action: "setNormalMode:", forControlEvents: .TouchUpInside)
        appDelegate.viewWidth =  self.view.bounds.width
        appDelegate.viewHeight =  self.view.bounds.height
        appDelegate.ratio =  self.view.bounds.width / 320.0
        if self.view.bounds.height <= 480.0 { appDelegate.is4s = true; }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func move(sender: AnyObject) {
        //        self.performSegueWithIdentifier("next",sender: nil)
        //        var nex : AnyObject! = self.storyboard.instantiateViewControllerWithIdentifier("next")
        //        self.presentViewController(nex as UIViewController, animated: true, completion: nil)
    }

    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }

    func setEasyMode(sender: AnyObject) {
        appDelegate.gameMode = "easy"
    }

    func setNormalMode(sender: AnyObject) {
        appDelegate.gameMode = "normal"
    }


}
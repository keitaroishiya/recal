//
//  ResultViewController.swift
//  recal
//
//  Created by K on 2015/06/03.
//  Copyright (c) 2015 K. All rights reserved.
//

import UIKit
//import QuartzCore

class ResultViewController: UIViewController {

	@IBOutlet var resultTimeLabel: UILabel!
	private var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		// var bt_back = UIBarButtonItem()
		// bt_back.title = ""

		// self.navigationItem.backBarButtonItem = bt_back
		// self.navigationController?.interactivePopGestureRecognizer.enabled = false
		self.navigationItem.hidesBackButton = true

		let bgImgView: UIImageView = UIImageView(frame: CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height))
		let bgImg = UIImage(named: "background_app.jpg")
		bgImgView.image = bgImg
		self.view.addSubview(bgImgView)
		self.view.sendSubviewToBack(bgImgView)

		resultTimeLabel.font = UIFont(name: "HiraKakuProN-W3", size: 24)
		// resultTimeLabel.text = String(format:"%.2f", appDelegate.playedTime) + "秒"
		resultTimeLabel.text = String(format:"%.2f", appDelegate.playedTime) + "sec"
	}

	override func prefersStatusBarHidden() -> Bool {
		return appDelegate.is4s
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
//
//  Utility.swift
//  recal
//
//  Created by K on 2015/01/30.
//  Copyright (c) 2015年 K. All rights reserved.
//

import UIKit


class Utility {

	// 以下のような形で実行します。
	// Utility.hex("45fb4b", alpha: 0.8)
	// (c) http://swift-salaryman.com/uicolorutil.php
	class func hex (var hexStr : NSString, var alpha : CGFloat) -> UIColor {
		hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
		let scanner = NSScanner(string: hexStr)
		var color: UInt32 = 0
		if scanner.scanHexInt(&color) {
			let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
			let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
			let b = CGFloat(color & 0x0000FF) / 255.0
			return UIColor(red:r,green:g,blue:b,alpha:alpha)
		} else {
			print("invalid hex string")
			return UIColor.whiteColor()
		}
	}

	// API取得の開始処理
	// (c) http://dev.classmethod.jp/references/ios-8-xcode-6-swift-api-json/
	class func getData(path: NSString) {
		let URL: NSURL = NSURL(string: path)!
		let req: NSURLRequest = NSURLRequest(URL: URL)
		let connection: NSURLConnection = NSURLConnection(request: req, delegate: self, startImmediately: false)!

		// NSURLConnectionを使ってAPIを取得する
		NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: response)
	}

	// 取得したAPIデータの処理
	class func response(res: NSURLResponse!, data: NSData!, error: NSError!){
		let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
		let answer:NSDictionary = json["answer"] as NSDictionary
		let questions:NSArray = json["question"] as NSArray

			println(answer["proccess"])
		// １行ずつログに表示
		for var i=0 ; i<answer.count ; i++ {
			// println(answer["proccess"])
		}
	}

}
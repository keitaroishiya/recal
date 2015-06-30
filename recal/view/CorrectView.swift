//
//  CorrectView
//  recal
//
//  Created by K on 2015/06/01.
//  Copyright (c) 2015年 K. All rights reserved.
//
import UIKit

class CorrectView: UIView {

	var viewWid: CGFloat = 320.0
	var sizeRatio: CGFloat = 1.0
	var firstX: Double = 0.0
	var labelMovePos: Double = 0.0
	var fontSize: CGFloat = 40.0
	var bgRect: UIView = UIView(frame: CGRectZero)
	var labelsAry: [UILabel] = []
	var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	var txts: [String] = ["C", "O", "R", "R", "E", "C", "T"]

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {
		super.init(frame: CGRectMake(0,0,0,0))
		// userInteractionEnabled = false
		// self.backgroundColor = UIColor.whiteColor()
	}

	// 初期設定
	func initSetting() {
		// println(answer)
		sizeRatio = appDelegate.ratio
		viewWid = appDelegate.viewWidth
		let halfW = viewWid * 0.5
		firstX = Double(halfW) - 120.0
		labelMovePos = Double(viewWid) + 100.0


		// self.frame = CGRectMake(0, 0, viewWid, ceil(100.0 * sizeRatio))
		bgRect.backgroundColor = Utility.hex("000000", alpha: 0.7)
		bgRect.frame.size = CGSizeMake(viewWid, 2000.0)
		bgRect.hidden = true
		addSubview(bgRect)

		for var i:Int=0,len:Int=txts.count; i<len; i+=1 {
			makeLabel(txts[i], index: i)
		}

	}

	// 正解のUILabelを作成するメソッド
	func makeLabel(txt: String, index: Int) -> UILabel {

		let labelView: UILabel = UILabel()
		labelView.textAlignment = NSTextAlignment.Center
		labelView.textColor = UIColor.whiteColor()
		labelView.font = UIFont(name: "HiraKakuProN-W6", size: fontSize)
		labelView.frame = CGRectMake(0.0, 0.0 * sizeRatio, fontSize, fontSize)
		labelView.layer.position = CGPoint(x: labelMovePos + firstX, y: 0.0)
		labelView.text = txt
		labelsAry.append(labelView)
		addSubview(labelView)

		return labelView
	}

	// 正解のアニメーションを開始
	func startAnimation() {

		self.bgRect.hidden = false
		self.bgRect.alpha = 0
		UIView.animateWithDuration(
			0.3,
			delay: 0.5,
			options: UIViewAnimationOptions.CurveEaseInOut,
			animations: {() -> Void  in
				self.bgRect.alpha = 1
			},
			completion: { (Bool) -> Void in }
		)

		for var i:Int=0,len:Int=labelsAry.count; i<len; i+=1 {
			labelAnimation(i)
			// println(i)
		}
	}

	func labelAnimation(i: Int) {
		// let yPos: Double = 70.0,
		let yPos: Double = Double(appDelegate.viewHeight * 0.5) - 60.0,
			index: Double = Double(i)
		self.labelsAry[i].layer.position = CGPoint(x: labelMovePos, y: yPos)

		UIView.animateWithDuration(
			0.2,
			delay: 0.05 * index + 1.0,
			options: UIViewAnimationOptions.CurveEaseInOut,
			animations: {() -> Void  in
				self.labelsAry[i].layer.position = CGPoint(x: index * 40.0 + self.firstX, y: yPos)
			},
			completion: { (Bool) -> Void in
				UIView.animateWithDuration(
					0.2,
					delay: 1.5,
					options: UIViewAnimationOptions.CurveEaseInOut,
					animations: {() -> Void  in
						self.labelsAry[i].layer.position = CGPoint(x: -100.0, y: yPos)
					},
					completion: { (Bool) -> Void in
						self.labelsAry[i].hidden = true
						if i == self.labelsAry.count - 1 {
							NSNotificationCenter.defaultCenter().postNotificationName("correctAnimationFinished", object: nil, userInfo: ["testNumber": 123])
							println("clear")
						}

					}
				)

			}
		)
	}
}

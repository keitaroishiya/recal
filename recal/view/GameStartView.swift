//
//  GameStartView
//  recal
//
//  Created by K on 2015/06/05.
//  Copyright (c) 2015年 K. All rights reserved.
//
import UIKit

class GameStartView: CorrectView {

	override var txts: [String] {
		get { return ["3", "2", "1"] }
		set { }
	}
	override var fontSize:CGFloat {
		get { return 100.0 }
		set { }
	}

	// 初期設定のメソッドをオーバーライド
	override func initSetting() {
		super.initSetting()
		startAnimation()

	}

	override func labelAnimation(i: Int) {
		let yPos: Double = Double(appDelegate.viewHeight * 0.5),
			index: Double = Double(i),
			halfW: Double = Double(viewWid * 0.5)

		self.labelsAry[i].layer.position = CGPoint(x: labelMovePos, y: yPos)

		UIView.animateWithDuration(
			0.2,
			delay: 1.0 * index + 1.0,
			options: UIViewAnimationOptions.CurveEaseInOut,
			animations: {() -> Void  in
				self.labelsAry[i].layer.position = CGPoint(x: halfW, y: yPos)
			},
			completion: { (Bool) -> Void in
				UIView.animateWithDuration(
					0.2,
					delay: 0.8,
					options: UIViewAnimationOptions.CurveEaseInOut,
					animations: {() -> Void  in
						self.labelsAry[i].layer.position = CGPoint(x: -100.0, y: yPos)
					},
					completion: { (Bool) -> Void in
						self.labelsAry[i].hidden = true
						if i == self.labelsAry.count - 1 {
							NSNotificationCenter.defaultCenter().postNotificationName("startAnimationFinished", object: nil)
							self.startGame()
							println("start")
						}

					}
				)

			}
		)
	}

	func startGame() {
		UIView.animateWithDuration(
			0.3,
			delay: 0,
			options: UIViewAnimationOptions.CurveEaseInOut,
			animations: {() -> Void  in
				self.bgRect.alpha = 0
			},
			completion: { (Bool) -> Void in
				self.hidden = true;
			}
		)
	}
}

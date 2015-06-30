//
//  DrawButtonView
//  recal
//
//  Created by K on 2015/06/01.
//  Copyright (c) 2015年 K. All rights reserved.
//
import UIKit

class DrawButtonView: UIView {

	private var type: String = ""
	private var value: Int = -1
	private var size: CGFloat = 0.0
	private var sizeRatio: CGFloat = 0.0
	private var normalColor: UIColor = Utility.hex("ffffff", alpha: 1.0)
	private var overColor: UIColor = Utility.hex("e50012", alpha: 1.0)
	private var correctColor: UIColor = Utility.hex("009fe8", alpha: 1.0)

	var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	// init() {
	// 	super.init(frame: CGRectMake(0,0,0,0))
	// 	// userInteractionEnabled = false
	// }

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clearColor()
		sizeRatio = appDelegate.ratio
	}

	func setParameter(img_type:String, n_val:Int) {
		type = img_type
		value = n_val
		size = self.frame.width
	}

	override func drawRect(rect: CGRect) {
		// 円を描画
		let margin: CGFloat = 5.0
		let cSize: CGFloat = size - margin * 2.0
		var rect: CGRect = CGRectMake(margin, margin, cSize, cSize)
		var oval: UIBezierPath = UIBezierPath(ovalInRect: rect)

		if type == "off" {
			normalColor.setStroke()
		}
		else if type == "on" {
			overColor.setStroke()
			overColor.setFill()
			oval.fill()
		}
		else if type == "done" {
			correctColor.setStroke()
			correctColor.setFill()
			oval.fill()
		}

		oval.lineWidth = 2.0
		oval.stroke()

		// 数字を配置
		let numLabel: UILabel = UILabel()
		var valStr: String = "";
		var fSize: CGFloat = 36.0
		switch value {
			case 11:
				valStr = "+"
				fSize = 40
				rect.origin.y -= 4 * sizeRatio
				break

			case 12:
				valStr = "−"
				fSize = 40
				rect.origin.y -= 4 * sizeRatio
				break

			case 13:
				valStr = "×"
				fSize = 40
				rect.origin.y -= 4 * sizeRatio
				break

			case 14:
				valStr = "÷"
				fSize = 40
				rect.origin.y -= 4 * sizeRatio
				break

			default:
				valStr = String(value)
				break
		}

		numLabel.text = valStr
		numLabel.textAlignment = NSTextAlignment.Center
		numLabel.baselineAdjustment = UIBaselineAdjustment.AlignBaselines
		numLabel.textColor = UIColor.whiteColor()
		numLabel.font = UIFont(name: "HiraKakuProN-W3", size: fSize * sizeRatio)
		numLabel.frame = rect
		// numLabel.layer.shadowColor = UIColor.blackColor().CGColor
		// numLabel.layer.shadowOffset = CGSizeMake(0.7, 0.7)
		// numLabel.layer.shadowOpacity = 0.3
		// numLabel.layer.shadowRadius = 0.5
		addSubview(numLabel)
	}
}

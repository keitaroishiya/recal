//
//  ButtonConnectLineView.swift
//  recal
//
//  Created by K on 2015/01/30.
//  Copyright (c) 2015年 K. All rights reserved.
//
import UIKit;

class ButtonConnectLineView: UIView {

	private var path: UIBezierPath = UIBezierPath();
	private var viewSize: CGSize = CGSize();
	private var isStart: Bool = false;
	private var lineColor: UIColor = Utility.hex("e50012", alpha: 1.0);
	private var correctColor: UIColor = Utility.hex("009fe8", alpha: 1.0);

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init() {
		super.init(frame: CGRectMake(0,0,0,0));
		userInteractionEnabled = false;
		// self.backgroundColor = UIColor.greenColor();
	}

	// 初期設定
	func initSetting(sqrSize:CGFloat) {
		self.frame = CGRectMake(0,0,sqrSize,sqrSize);
		viewSize = CGSize(width: sqrSize, height: sqrSize);
		resetPath();
	}

	// 線の描画処理
	func drawLine(pos:CGPoint) {

		// CoreGraphicsで描画する
		UIGraphicsBeginImageContextWithOptions(viewSize, false, 0);

		// 描画する
		if !isStart {
			path.moveToPoint(pos);
			path.addLineToPoint(pos);
			isStart = true;
		} else {
			path.addLineToPoint(pos);
		}
		lineColor.setStroke();
		path.stroke();

		// viewのlayerに描画したものをセットする
		self.layer.contents = UIGraphicsGetImageFromCurrentImageContext().CGImage;
		UIGraphicsEndImageContext();
	}

	// 線の描画処理
	func drawCorrectLine() {

		// CoreGraphicsで描画する
		UIGraphicsBeginImageContextWithOptions(viewSize, false, 0);

		correctColor.setStroke();
		path.stroke();

		// viewのlayerに描画したものをセットする
		self.layer.contents = UIGraphicsGetImageFromCurrentImageContext().CGImage;
		UIGraphicsEndImageContext();
	}

	// 空の領域を描画して線描画をクリアする
	func clearLine() {
		UIGraphicsBeginImageContextWithOptions(viewSize, false, 0);
		self.layer.contents = UIGraphicsGetImageFromCurrentImageContext().CGImage;
		UIGraphicsEndImageContext();

		isStart = false;
		resetPath();
	}

	// UIBezierPathを初期化
	private func resetPath() {
		path = UIBezierPath();
		path.lineWidth = 4;
	}

}

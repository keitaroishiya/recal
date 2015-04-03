//
//  AnswerView
//  recal
//
//  Created by K on 2015/02/02.
//  Copyright (c) 2015年 K. All rights reserved.
//
import UIKit;

class AnswerView: UIView {

	private let conditionLabel: UILabel = UILabel();
	private let timerLabel: UILabel = UILabel();
	private let questionLabel: UILabel = UILabel();
	private var viewWid: CGFloat = 320.0;
	private var sizeRatio: CGFloat = 1.0;
	private var timer: NSTimer!;
	private var isTimer: Bool = false;
	private var timerCount: Int = 0;

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init() {
		super.init(frame: CGRectMake(0,0,0,0));
		// userInteractionEnabled = false;
		// self.backgroundColor = UIColor.whiteColor();
	}

	// 初期設定
	func initSetting(answer:NSDictionary, ratio:CGFloat) {
		// println(answer);
		sizeRatio = ratio;
		viewWid = ceil(320.0 * sizeRatio);
		let halfW = viewWid * 0.5;

		self.frame = CGRectMake(0, 60.0, viewWid, ceil(100.0 * sizeRatio));

		questionLabel.textAlignment = NSTextAlignment.Center;
		questionLabel.textColor = UIColor.whiteColor();
		questionLabel.font = UIFont.systemFontOfSize(40.0);
		questionLabel.frame = CGRectMake(0, 40.0 * sizeRatio, viewWid, 50.0);
		self.addSubview(questionLabel);

		conditionLabel.textAlignment = NSTextAlignment.Left;
		conditionLabel.textColor = UIColor.whiteColor();
		conditionLabel.font = UIFont.systemFontOfSize(20.0);
		conditionLabel.frame = CGRectMake(10.0 * sizeRatio, 0, ceil(180.0 * sizeRatio), 50.0);
		self.addSubview(conditionLabel);

		timerLabel.textAlignment = NSTextAlignment.Right
		timerLabel.textColor = UIColor.whiteColor();
		timerLabel.font = UIFont.systemFontOfSize(20.0);
		timerLabel.frame = CGRectMake(180.0 * sizeRatio,0, ceil(130.0 * sizeRatio), 50.0);
		self.addSubview(timerLabel);

		let ans: Int = answer["value"] as Int;
		let chain: Int = answer["chain"] as Int;

		isTimer = true;
		timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true);


		setQuestionText(String(ans));
		setConditionText(String(chain) + "連結で");
		setTimerText(0);
	}

	internal func timerHandler() {
		if isTimer {
			timerCount++;
			setTimerText(timerCount);
		}
	}

	func stopTimer() {
		isTimer = false;
		timer.invalidate();
	}

	func setQuestionText(txt: String?) {
		questionLabel.text = txt;
	}

	func setConditionText(txt: String) {
		conditionLabel.text = txt;
	}

	func setTimerText(sec:Int) {
		timerLabel.text = "time: " + String(sec) + "秒";
	}
}

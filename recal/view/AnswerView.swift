//
//  AnswerView
//  recal
//
//  Created by K on 2015/02/02.
//  Copyright (c) 2015年 K. All rights reserved.
//
import UIKit

class AnswerView: UIView {

	private let conditionLabel: UILabel = UILabel()
	private let timerLabel: UILabel = UILabel()
	private let questionLabel: UILabel = UILabel()
	private let correct: CorrectView = CorrectView()
	private var viewWid: CGFloat = 320.0
	private var sizeRatio: CGFloat = 1.0
	private var timer: NSTimer!
	private var isTimer: Bool = false
	private var timerCount: Int = 0

	private var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	private var startSec: Double = NSDate().timeIntervalSince1970
	private var playedTimeData: Double = 0.0

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {
		super.init(frame: CGRectMake(0,0,0,0))
		// userInteractionEnabled = false
		// self.backgroundColor = UIColor.whiteColor()
	}

	// 初期設定
	func initSetting(answer:NSDictionary) {
		// println(answer)
		sizeRatio = appDelegate.ratio
		viewWid = ceil(320.0 * sizeRatio)
		let halfW = viewWid * 0.5

		// self.frame = CGRectMake(0, 60.0, viewWid, ceil(100.0 * sizeRatio))

		questionLabel.textAlignment = NSTextAlignment.Center
		questionLabel.textColor = UIColor.whiteColor()
		questionLabel.font = UIFont(name: "HiraKakuProN-W3", size: 40)
		questionLabel.frame = CGRectMake(0, 40.0, viewWid, 50.0)
		// questionLabel.layer.shadowColor = UIColor.blackColor().CGColor
		// questionLabel.layer.shadowOffset = CGSizeMake(0.7, 0.7)
		// questionLabel.layer.shadowOpacity = 0.3
		// questionLabel.layer.shadowRadius = 0.5
		self.addSubview(questionLabel)

		conditionLabel.textAlignment = NSTextAlignment.Left
		conditionLabel.textColor = UIColor.whiteColor()
		conditionLabel.numberOfLines = 0
		conditionLabel.sizeToFit()
		conditionLabel.font = UIFont(name: "HiraKakuProN-W3", size: 20)
		conditionLabel.frame = CGRectMake(10.0 * sizeRatio, 0, ceil(150.0 * sizeRatio), 50.0)
		self.addSubview(conditionLabel)

		timerLabel.textAlignment = NSTextAlignment.Right
		timerLabel.textColor = UIColor.whiteColor()
		timerLabel.font = UIFont(name: "HiraKakuProN-W3", size: 20)
		timerLabel.frame = CGRectMake(150.0 * sizeRatio,0, ceil(160.0 * sizeRatio), 50.0)
		self.addSubview(timerLabel)

		let ans: Int = answer["value"] as! Int
		let step: Int = answer["step"] as! Int

		isTimer = true
		timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true)


		setQuestionText(String(ans))
		// setConditionText(String(step) + "手で")
		setConditionText("steps: " + String(step))
		setTimerText(0)

		correct.initSetting()
		self.addSubview(correct)

		// println(correct.layer.position)
	}

	internal func timerHandler() {
		if isTimer {
			timerCount++
			setTimerText(timerCount)
		}
	}

	func stopTimer() {
		isTimer = false
		timer.invalidate()
	}

	private func setQuestionText(txt: String?) {
		questionLabel.text = txt
	}

	private func setConditionText(txt: String) {
		conditionLabel.text = txt
	}

	private func setTimerText(sec:Int) {
		playedTimeData = NSDate().timeIntervalSince1970 - startSec;
		// playedTimeData = Double(sec) / 100
		var st: String = String(format:"%.2f", playedTimeData)
		// timerLabel.text = "time: " + st + "秒"
		timerLabel.text = "time: " + st + "sec"
	}

	func getPlayedTime() -> Double {
		return playedTimeData
	}

	func gameCleared() {
		correct.startAnimation()
	}
}

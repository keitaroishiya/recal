//
//  NextViewController.swift
//  recal
//
//  Created by K on 2014/12/21.
//  Copyright (c) 2014年 K. All rights reserved.
//

import UIKit
import AVFoundation

class NextViewController: UIViewController {

	@IBOutlet var timerLabel: UILabel!
	@IBOutlet var proccessLabel: UILabel!
	@IBOutlet var answerLabel: UILabel!
	@IBOutlet weak var correctBg: UIView!
	@IBOutlet weak var redBarView: UIView!

	private var gameMode: String = ""
	private var fileName: String = "n"
	private var columnN: Int = 0
	private var sizeRatio: CGFloat = 0
	private var btnAry: [NumberButtonView]! = []
	private let connectLine: ButtonConnectLineView = ButtonConnectLineView()

	// 計算結果を表示するView
	private let gameStart: GameStartView = GameStartView()
	private let answer: AnswerView = AnswerView()
	private let btnView: UIView = UIView()

	//タッチ処理関連の変数
	private var isFinish: Bool = false
	private var touching: Int = -1
	private var touchHead: Int = -1
	private var idOrder: [Int] = []
	private var numOrder: [Int] = []
	private var btnOnAry: [Bool]! = []
	private var jsonData: NSDictionary!
	private var questionAry:[Int]!
	private var answerVal: String!
	private var answerStep: Int!

	//タッチ可能判別処理関連の変数
	private var lastRow: Int = 0
	private var availableAry: [Int]! = []

	private var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//	private let appFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size;	//Display size

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		self.view.multipleTouchEnabled = true
		self.navigationController?.setNavigationBarHidden(false, animated: true)

		var bt_back = UIBarButtonItem()
		bt_back.title = ""
		self.navigationItem.backBarButtonItem = bt_back
		self.navigationController?.interactivePopGestureRecognizer.enabled = false
		self.navigationItem.hidesBackButton = true

		gameMode = appDelegate.gameMode
		switch gameMode {
			case "easy":
				columnN = 3
				fileName = "e"
				break

			case "hard":
				columnN = 7
				fileName = "h"
				break

			default:
				columnN = 5
				break
		}
		lastRow = columnN * (columnN - 1)
		appDelegate.columnN = columnN
		sizeRatio = appDelegate.ratio
		redBarView.alpha = 0

		let bgImgView: UIImageView = UIImageView(frame: CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height))
		let bgImg = UIImage(named: "background_app.jpg")
		bgImgView.image = bgImg
		self.view.addSubview(bgImgView)
		self.view.sendSubviewToBack(bgImgView)

		// 計算結果を表示するView
		self.view.addSubview(answer)
		answer.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.view.addConstraints([
			NSLayoutConstraint(
				item: answer,
				attribute: NSLayoutAttribute.Top,
				relatedBy: NSLayoutRelation.Equal,
				toItem: self.topLayoutGuide,
				attribute: NSLayoutAttribute.Bottom,
				multiplier: 1.0,
				constant: 0.0
			)]
		)

		// ボタンとつなげる線を描画するViewの親View
		// let btnView: UIView = UIView()
		btnView.layer.position = CGPoint(x: 0.0, y: 233.0)
		btnView.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.view.addSubview(btnView)

		// つなげる線を描画するView
		btnView.addSubview(connectLine)
		connectLine.initSetting(self.view.bounds.width)

		self.view.addSubview(gameStart)
		loadLocalData()
		// loadQuestionData()
	}

	override func prefersStatusBarHidden() -> Bool {
		return appDelegate.is4s
	}

	func loadQuestionData() {
		let path: NSString = "http://iamworks.com/recal/data/" + gameMode + "/1.json"
		getData(path)
	}

	// API取得の開始処理
	// (c) http://dev.classmethod.jp/references/ios-8-xcode-6-swift-api-json/
	func getData(path: NSString) {
		let URL: NSURL = NSURL(string: path as String)!
		let req: NSURLRequest = NSURLRequest(URL: URL)
		let connection: NSURLConnection = NSURLConnection(request: req, delegate: self, startImmediately: false)!

		// NSURLConnectionを使ってAPIを取得する
		NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: response)
	}

	// 埋め込みJSONを取得
	func loadLocalData() {
		let _file: String = fileName + String(arc4random_uniform(15))
		// let _file: String = fileName + "1"

		let path: String = NSBundle.mainBundle().pathForResource(_file, ofType: "json")!
		let fileHandle: NSFileHandle = NSFileHandle(forReadingAtPath: path)!
		let data: NSData = fileHandle.readDataToEndOfFile()
		response(nil, data: data, error: nil);
	}

	// 取得したAPIデータの処理
	func response(res: NSURLResponse!, data: NSData!, error: NSError!){
		jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
		// println(jsonData)
		// questionAry = json["question"] as [Int]

		// １行ずつログに表示
		for var i=0 ; i<jsonData.count ; i++ {
			// println(jsonData[i])
		}

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "generateButtons:", name: "startAnimationFinished", object: nil)
		self.view.bringSubviewToFront(gameStart)
		gameStart.initSetting()
		// generateButtons()
	}

	func generateButtons(notification: NSNotification?) {
		NSNotificationCenter.defaultCenter().removeObserver(self)
		self.navigationItem.hidesBackButton = false

		UIView.animateWithDuration(
			0.3,
			delay: 0.0,
			options: UIViewAnimationOptions.CurveEaseInOut,
			animations: {() -> Void  in
				self.redBarView.alpha = 1
			},
			completion: { (Bool) -> Void in }
		)

		let questionAry: [Int] = jsonData["question"] as! [Int]
		let answerAry: NSDictionary = jsonData["answer"] as! NSDictionary
		let len: Int = columnN * columnN
		// ボタンを生成
		for var i:Int=0; i<len; i+=1 {
			var _btn: NumberButtonView = NumberButtonView()
			_btn.generateButton(i, val: questionAry[i])

			// ボタンをbtnViewに追加
			btnView.addSubview(_btn)
			btnAry.append(_btn)
			btnOnAry.append(false)
		}

		answer.initSetting(answerAry)
		answerVal = String(answerAry["value"] as! Int)
		answerStep = answerAry["step"] as! Int

		if appDelegate.is4s {
			self.view.addConstraints([
				NSLayoutConstraint(
					item: btnView,
					attribute: NSLayoutAttribute.Top,
					relatedBy: NSLayoutRelation.Equal,
					toItem: redBarView,
					attribute: NSLayoutAttribute.Bottom,
					multiplier: 1.0,
					constant: 0.0
				)]
			)
		}

		self.view.bringSubviewToFront(proccessLabel)
		self.view.bringSubviewToFront(answerLabel)
		self.view.bringSubviewToFront(answer)
		// self.view.sendSubviewToBack(redBarView)

		resetAll()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// @IBAction func goBack(sender: AnyObject) {
	// 	self.navigationController?.popToRootViewControllerAnimated(true)
	// }

	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		checkTouched(touches, event: event)
	}

	override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
		checkTouched(touches, event: event)
	}

	override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		println("end")
		resetAll()
	}

	override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent) {
		println("cancel")
		resetAll()
	}

	// ボタンのタッチオーバーと計算をリセット
	private func resetAll() {
		if isFinish {
			waitingForResult()
			answer.gameCleared()
			return
		}

		for var i:Int=0,len:Int=btnAry.count; i<len; i+=1 {
			btnAry[i].resetRollover()
			btnOnAry[i] = false
		}
		touching = -1
		touchHead = -1
		idOrder.removeAll()
		numOrder.removeAll()
		availableAry.removeAll()
		proccessLabel.text = ""
		answerLabel.text = "0"
		connectLine.clearLine()
		correctBg.hidden = true
	}

	// ボタンにタッチオンしているかをチェックするメソッド
	func checkTouched(touches: NSSet, event: UIEvent) {
		if isFinish { return; }

		var nmb: Int, val: Int, isTouched: Bool;
		for touch: AnyObject in touches {
			var t: UITouch = touch as! UITouch
			for bt: NumberButtonView in btnAry {
				nmb = bt.getId()
				if nmb != touching {
					if isTouchable(nmb) {
						isTouched = btnOnAry[nmb]

						if numOrder.count == 0 {
							val = bt.getValue()
							if val == 0 || val > 10 {
								continue;
							}
						}

						if bt.checkTouching(t, event: event) {
							touching = nmb
							if !isTouched {


								touchHead = bt.getId()
								idOrder += [touchHead]
								numOrder += [bt.getValue()]
								btnOnAry[nmb] = true
								availableBtnSet(touchHead)
								connectLine.drawLine(bt.getPosition())
							}
							calculate()
						}
					}
				}
			}
		}
	}

	private func availableBtnSet(head: Int) {
		var upNum: Int,
			downNum: Int,
			leftNum: Int,
			rightNum: Int

		upNum = (head >= columnN) ? head - columnN : -1
		downNum = (head < lastRow) ? head + columnN : -1
		leftNum = (head % columnN > 0) ? head - 1 : -1
		rightNum = ((head+1) % columnN == 0) ? -1 : head + 1
		availableAry = [ upNum, downNum, leftNum, rightNum ]
	}

	private func isTouchable(nmb: Int) -> Bool {
		if availableAry.count == 0 {
			return true
		}

		for i:Int in availableAry {
			if nmb == i {
				return true
			}
		}
		return false
	}

	private func calculate() {
		var temp: Int, i: Int = 0, len: Int = idOrder.count
		var oper: Int = 0
		var operLabel: String = ""
		var result: Double = 0.0
		var resultLabel: String = ""
		var label: String = ""
		var a: NSString = "", b: NSString = ""

		for i=0; i<len; i+=1 {
			temp = numOrder[i]
			if temp > 10 {
				oper = temp
			}
			else {
				if oper == 0 {
					a = (a as String) + (NSString(string: String(temp)) as String)
				}
				else {
					b = (b as String) + (NSString(string: String(temp)) as String)
				}
			}
		}
		if oper == 11 {
			operLabel = "+"
			result = a.doubleValue + b.doubleValue
		} else if oper == 12 {
			operLabel = "-"
			result = a.doubleValue - b.doubleValue
		}

		if a != "" {
			if b != "" {
				if oper == 11 {
					result = a.doubleValue + b.doubleValue
				} else if oper == 12 {
					result = a.doubleValue - b.doubleValue
				}
			}
			else {
					result = a.doubleValue
			}
		}
		else {
			result = 0.0
		}

		label = String((a as String) + " " + operLabel + " " + (b as String) + " = ")
		proccessLabel.text = label
		resultLabel = String(NSString(format: "%.f", result))
		answerLabel.text = resultLabel

		// 正解時
		if idOrder.count == answerStep {
			if answerVal == resultLabel {
				println(answerVal + " / " + resultLabel)
				connectLine.drawCorrectLine()
				answer.stopTimer();
				correctBg.hidden = false
				isFinish = true

				// バイブを作動
				AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

				// 戻るボタンは非表示
				self.navigationItem.hidesBackButton = true

				for i=0; i<len; i+=1 {
					btnAry[idOrder[i]].correctAnswer()
				}
			}
		}
	}

	// 正解アニメーションの完了を監視するリスナーを登録
	private func waitingForResult() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveToResult:", name: "correctAnimationFinished", object: nil)
	}

	// 結果画面へ遷移
	func moveToResult(notification: NSNotification?) {
		appDelegate.playedTime = answer.getPlayedTime()
		NSNotificationCenter.defaultCenter().removeObserver(self)
		self.performSegueWithIdentifier("resultSegue",sender: self)
		// var result : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("result")
		// self.presentViewController(result as! UIViewController, animated: true, completion: nil)
	}

	func sendGameMode(mode: String) {
		println("mode" + mode)
	}

}


//
//  NextViewController.swift
//  recal
//
//  Created by K on 2014/12/21.
//  Copyright (c) 2014年 K. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

	@IBOutlet var timerLabel: UILabel!;
	@IBOutlet var questionLabel: UILabel!;
	@IBOutlet var proccessLabel: UILabel!;
	@IBOutlet var answerLabel: UILabel!;
	@IBOutlet weak var correctBg: UIView!;

	private var gameMode: String = "normal";
	private var columnN: Int = 0;
	private var sizeRatio: CGFloat = 0;
	private var btnAry: [NumberButtonView]! = [];
	private let connectLine: ButtonConnectLineView = ButtonConnectLineView();

	// 計算結果を表示するView
	private let answer: AnswerView = AnswerView();
	private let btnView: UIView = UIView();

	//タッチ処理関連の変数
	private var touching: Int = -1;
	private var touchHead: Int = -1;
	private var idOrder: [Int] = [];
	private var numOrder: [Int] = [];
	private var btnOnAry: [Bool]! = [];
	private var jsonData: NSDictionary!;
	private var questionAry:[Int]!;
	private var answerVal: String!;

	//タッチ可能判別処理関連の変数
	private var lastRow: Int = 0;
	private var availableAry: [Int]! = [];

//	private let appFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size;	//Display size

	override func viewDidLoad() {
		super.viewDidLoad();

		// Do any additional setup after loading the view, typically from a nib.
		self.view.multipleTouchEnabled = true;
		self.navigationController?.setNavigationBarHidden(false, animated: true);

		switch gameMode {
			case "easy":
				columnN = 3;
				break;

			case "hard":
				columnN = 7;
				break;

			default:
				columnN = 5;
				break;
		}
		lastRow = columnN * (columnN - 1);

		// Show
//		let appFrameSizeStr: NSString = "applicationFrame width: \(appFrameSize.width) NativeBoundheight: \(appFrameSize.height)";

		sizeRatio = self.view.bounds.width / 320.0;
		// println(sizeRatio);
		self.view.addSubview(answer);

		let bgImgView: UIImageView = UIImageView(frame: CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height));
		let bgImg = UIImage(named: "background_app.jpg");
		bgImgView.image = bgImg;
		self.view.addSubview(bgImgView);

		// 計算結果を表示するView
		self.view.addSubview(answer);

		// ボタンとつなげる線を描画するViewの親View
		// let btnView: UIView = UIView();
		btnView.layer.position = CGPoint(x: 0.0, y: 233.0 * sizeRatio);
		self.view.addSubview(btnView);

		// つなげる線を描画するView
		btnView.addSubview(connectLine);
		connectLine.initSetting(self.view.bounds.width);

		loadQuestionData();
	}

	func loadQuestionData() {
		let path: NSString = "http://iamworks.com/q.json";
		getData(path);
	}

	// API取得の開始処理
	// (c) http://dev.classmethod.jp/references/ios-8-xcode-6-swift-api-json/
	func getData(path: NSString) {
		let URL: NSURL = NSURL(string: path)!
		let req: NSURLRequest = NSURLRequest(URL: URL)
		let connection: NSURLConnection = NSURLConnection(request: req, delegate: self, startImmediately: false)!

		// NSURLConnectionを使ってAPIを取得する
		NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: response)
	}

	// 取得したAPIデータの処理
	func response(res: NSURLResponse!, data: NSData!, error: NSError!){
		jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary;
		// questionAry = json["question"] as [Int];

			// println(answer["proccess"])
		// １行ずつログに表示
		for var i=0 ; i<jsonData.count ; i++ {
			// println(jsonData[i]);
		}

		generateButtons();
	}

	func generateButtons() {
		let questionAry: [Int] = jsonData["question"] as [Int];
		let answerAry: NSDictionary = jsonData["answer"] as NSDictionary;
		// ボタンを生成
		for var i:Int=0; i<25; i+=1 {
			var _btn: NumberButtonView = NumberButtonView();
			_btn.generateButton(i, val: questionAry[i], ratio: sizeRatio);

			// ボタンをbtnViewに追加
			btnView.addSubview(_btn);
			btnAry.append(_btn);
			btnOnAry.append(false);
		}

		answer.initSetting(answerAry, ratio: sizeRatio);
		answerVal = String(answerAry["value"] as Int);


		self.view.bringSubviewToFront(answer);
		for i in view.subviews {
			// println(i)
		}

		resetAll();
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// @IBAction func goBack(sender: AnyObject) {
	// 	self.navigationController?.popToRootViewControllerAnimated(true);
	// }

	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		checkTouched(touches, event: event);
	}

	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		checkTouched(touches, event: event);
	}

	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		println("end");
		resetAll();
	}

	override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
		println("cancel");
		resetAll();
	}

	// ボタンのタッチオーバーと計算をリセット
	private func resetAll() {
		for var i:Int=0,len:Int=btnAry.count; i<len; i+=1 {
			btnAry[i].resetRollover();
			btnOnAry[i] = false;
		}
		touching = -1;
		touchHead = -1;
		idOrder.removeAll();
		numOrder.removeAll();
		availableAry.removeAll();
		proccessLabel.text = "";
		answerLabel.text = "0";
		connectLine.clearLine();
		correctBg.hidden = true;
	}

	// ボタンにタッチオンしているかをチェックするメソッド
	func checkTouched(touches: NSSet, event: UIEvent) {
		var nmb: Int, isTouched: Bool;
		for touch: AnyObject in touches {
			var t: UITouch = touch as UITouch;
			for bt: NumberButtonView in btnAry {
				nmb = bt.getId();
				if nmb != touching {
					if isTouchable(nmb) {
						isTouched = btnOnAry[nmb];
						if bt.checkTouching(t, event: event) {
							touching = nmb;
							if !isTouched {
								touchHead = bt.getId();
								idOrder += [touchHead];
								numOrder += [bt.getValue()];
								btnOnAry[nmb] = true;
								availableBtnSet(touchHead);
								connectLine.drawLine(bt.getPosition());
							}

	// println(numOrder);
							calculate();
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
			rightNum: Int;

		upNum = (head >= columnN) ? head - columnN : -1;
		downNum = (head < lastRow) ? head + columnN : -1;
		leftNum = (head % columnN > 0) ? head - 1 : -1;
		rightNum = head + 1;
		availableAry = [ upNum, downNum, leftNum, rightNum ];
	}

	private func isTouchable(nmb: Int) -> Bool {
		if availableAry.count == 0 {
			return true;
		}

		for i:Int in availableAry {
			if nmb == i {
				return true;
			}
		}
		return false;
	}

	private func calculate() {
		var temp: Int, i: Int = 0, len: Int = idOrder.count;
		var oper: Int = 0;
		var result: Double = 0.0;
		var resultLabel: String = "";
		var label: String = "";
		var a: NSString = "", b: NSString = "";

		for i=0; i<len; i+=1 {
			temp = numOrder[i];
			if temp > 10 {
				oper = temp;
			}
			else {
				if oper == 0 {
					a = a + NSString(string: String(temp));
				}
				else {
					b = b + NSString(string: String(temp));
				}
			}
		}
		if a != "" {
			if b != "" {
				result = a.doubleValue + b.doubleValue;
			}
			else {
					result = a.doubleValue;
			}
		}
		else {
			result = 0.0;
		}

		label = String(a + " + " + b + " = ");
		proccessLabel.text = label;
		resultLabel = String(NSString(format: "%.f", result));
		answerLabel.text = resultLabel;

		if answerVal == resultLabel {
			println(answerVal + " / " + resultLabel);
			connectLine.drawCorrectLine();

			for i=0; i<len; i+=1 {
				btnAry[idOrder[i]].correctAnswer();
				correctBg.hidden = false;
				answer.stopTimer();
			}
		}
	}

}


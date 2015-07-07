//
//  BlinkingScreenViewController.swift
//  BlinkingScreen
//
//  Created by lunner on 3/29/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import UIKit

let ShouldDismissNotification = "ShouldDismissNotification"

class BlinkingScreenViewController: UIViewController {
	var numToColor: NumToColorSit?
	var timeCount: Int = 1
	
	override func viewDidLoad() {
		let string = NSString(string: numToColor!.numSequence)
		let index = characterToNum( string.characterAtIndex(0) )
		let rawColor = numToColor?.numToColors[index]
		let color = UIColor(red: rawColor!.R, green: rawColor!.G, blue: rawColor!.B, alpha: 1.0)
		view.backgroundColor = color
		
		let center = NSNotificationCenter.defaultCenter()
		center.addObserver(self, selector: "dismiss:", name: ShouldDismissNotification, object: nil)

	}
	

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		let duration = numToColor!.duration
		NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: "blinkingTheScreen:", userInfo: nil, repeats: true)
	}
	
	func blinkingTheScreen(timer: NSTimer) {
		let string = NSString(string: numToColor!.numSequence)
		if timeCount >= string.length {
			timer.invalidate()
			timeCount = 1
			postShouldDismissNotification()
			return 
		}
		let index = characterToNum( string.characterAtIndex(timeCount) )
		let rawColor = numToColor?.numToColors[index]
		let color = UIColor(red: rawColor!.R, green: rawColor!.G, blue: rawColor!.B, alpha: 1.0)
		view.backgroundColor = color
		view.setNeedsDisplay()
		++timeCount

	}
	func postShouldDismissNotification() {
		let center = NSNotificationCenter.defaultCenter()
		center.postNotificationName(ShouldDismissNotification, object: self)
	}
	func dismiss(notification: NSNotification) {
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
}

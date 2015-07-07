//
//  SetViewController.swift
//  BlinkingScreen
//
//  Created by lunner on 3/25/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import UIKit



class SetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	
	@IBOutlet var numPickerView: UIPickerView!
	@IBOutlet var durationSlider: UISlider!
	@IBOutlet var brightnessSlider: UISlider!
	@IBOutlet var durationTextField: UITextField!
	@IBOutlet var brightnessTextField: UITextField!
	@IBOutlet var rTextField: UITextField!
	@IBOutlet var gTextField: UITextField!
	@IBOutlet var bTextField: UITextField!
	@IBOutlet var colorDemonstrateView: UIView!
	
	var numToColor: NumToColorSit?
	
	let numOfComponents = 1
	let numOfRows = 10
	
		
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
//		if let tempReference = (presentingViewController as? ViewController)?.currentNumToColor {
//			currentNumToColorReference = tempReference
//		}
//		else {
//			//currentNumToColorReference = NumToColorSit(
//			print("currentNumToColorReference is nil")
//		}
//		
				
		
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		if let tempReference = (presentingViewController as? ViewController)?.currentNumToColor {
//			currentNumToColorReference = tempReference
//		}
//		else {
//			//currentNumToColorReference = NumToColorSit(
//			print("currentNumToColorReference is nil")
//		}


		//set duration and brightness display
		durationTextField.placeholder = "ms"
		brightnessTextField.placeholder = "°"
		
		configurePickerView()
	
		setBrightness()
		setDuration()
		setColorDemonstrateView()
		
		let center = NSNotificationCenter.defaultCenter()
		center.addObserver(self, selector: "durationDidChange:", name: DurationChangedNotification, object: nil)
		center.addObserver(self, selector: "brightnessDidChange:", name: BrightnessChangedNotification, object: nil)
		//center.addObserver(self, selector: "currentNumDidChange:", name: CurrentNumChangedNotification, object: nil)

	}
	
	func configurePickerView() {
		numPickerView.showsSelectionIndicator = true
		let selectedRow = numToColor!.currentNum
		numPickerView.selectRow(selectedRow, inComponent: 0, animated: true)
		pickerView(numPickerView, didSelectRow: selectedRow, inComponent: 0)
	}
	
	// MARK: UIPickerViewDataSource
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return numOfComponents
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return numOfRows
	}
	// MARK: UIPickerViewDelegate
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		return String(row)
		
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		numToColor?.currentNum = row
		// view's value should update to 
		
		updateRGBTextField()
		setColorDemonstrateView()
	}
	
	func updateRGBTextField() {
		setRTextField()
		setGTextField()
		setBTextField()
	}
	
	func setRTextField() {
		//rTextField.text = numToColor!.numToColors[numToColor!.currentNum].CGColor
		rTextField.text = "\(Int(numToColor!.numToColors[numToColor!.currentNum].R * 255.0))"
	}
	
	func setGTextField() {
		gTextField.text = "\(Int(numToColor!.numToColors[numToColor!.currentNum].G * 255.0))"
	}
	
	func setBTextField() {
		bTextField.text = "\(Int(numToColor!.numToColors[numToColor!.currentNum].B * 255.0))"
	}
	
	func setDuration() {
		let value = numToColor!.duration
		durationSlider.value = Float(value)
		let text = NSString(format: "%d", Int(Float(value) * 7000.0))
		durationTextField.text = text
	}
	
	func setBrightness() {
		let value = numToColor!.brightness
		brightnessSlider.value = Float(value)
		
		let text = NSString(format: "%0.0f", Float(value) * 360.0)
		brightnessTextField.text = text
	}
	
	func setColorDemonstrateView() {
		let curNum :Int! = numToColor?.currentNum
		let color = UIColor(red: numToColor!.numToColors[curNum].R, green: numToColor!.numToColors[curNum].G, blue: numToColor!.numToColors[curNum].B, alpha: numToColor!.numToColors[curNum].A)
		colorDemonstrateView.backgroundColor = color 
	}
	
	func showAnAlert(){
		let message = "Invalid number inputed!"
		let alert = UIAlertController(title: "Could not extrat number", message: message, preferredStyle: .Alert)
		let okAction = UIAlertAction(title: "That's Sad", style: .Default, handler: nil)
		alert.addAction(okAction)
		presentViewController(alert, animated: true, completion: nil)
	}
	
	@IBAction func changedTextField(sender: UITextField!) {	
		switch sender {
		case rTextField:
			let num = numToColor!.currentNum
			if rTextField.text == nil {
				// set default value or have an alert?
				self.numToColor!.numToColors[num].R = defaultR
				setRTextField()
				setColorDemonstrateView()
			}
			else {
				//self.currentNumToColorReference!.numToColors[currentNumToColorReference!.currentNum]
				if let r = translateToFloat(rTextField, value: rTextField.text, maxValue: 255.0) {
					numToColor!.numToColors[num].R = r
					setColorDemonstrateView()
				} else {
					// input invalid number alert then set text to original text
					
					// MARK: add alert
					showAnAlert()
					setRTextField()
				}

			}
			
		case gTextField:
			let num = numToColor!.currentNum
			if gTextField.text == nil {
				// set default
				self.numToColor!.numToColors[num].G = defaultG
				setGTextField()
				setColorDemonstrateView()
			}
			else {
				if let g = translateToFloat(gTextField, value: gTextField.text, maxValue: 255.0) {
					numToColor!.numToColors[num].G = g 
					setColorDemonstrateView()
				} else {
					showAnAlert()
					setGTextField()
				}
				
			}
			
		case bTextField:
			let num = numToColor!.currentNum
			if bTextField.text == nil {
				numToColor!.numToColors[num].B = defaultB
				setBTextField()
				setColorDemonstrateView()
			} else {
				if let b = translateToFloat(bTextField, value: bTextField.text, maxValue: 255.0) {
					numToColor!.numToColors[num].B = b 
					setColorDemonstrateView()
				} else {
					showAnAlert()
					setBTextField()
				}
			}
		case durationTextField:
			if durationTextField.text == nil {
				numToColor!.duration = defaultDuration //duration changed post a notification
			} else {
				if let duration = translateToFloat(durationTextField, value: durationTextField.text, maxValue: 7000.0) {
					numToColor!.duration = NSTimeInterval(duration) // post a notification
				} else {
					showAnAlert()
					setDuration()
				}
			}
		case brightnessTextField:
			if brightnessTextField == nil {
				numToColor!.brightness = defaultBrightness // post a notification
			} else {
				if let brightness = translateToFloat(brightnessTextField, value: brightnessTextField.text, maxValue: 360.0) {
					numToColor!.brightness = brightness // post a notification
				} else {
					showAnAlert()
					setDuration()
				}
			}
		default:
			break
		}
	}
	
	@IBAction func changedSlider(sender: UISlider!) {
		switch sender {
		case durationSlider:
			self.numToColor?.duration = NSTimeInterval(durationSlider.value)
			
		case brightnessSlider:
			self.numToColor?.brightness = CGFloat(brightnessSlider.value)
		default: 
			break
		}
	}
	@IBAction func clearCurrentNum(sender: AnyObject) {
		let currentNum = numToColor!.currentNum
		numToColor?.setDefaultsAtNumWithoutNumSequence(currentNum)
		//RGB display to default
		rTextField.text = "0"
		gTextField.text = "0"
		bTextField.text = "0"
		let color = UIColor.blackColor()
		colorDemonstrateView.backgroundColor = color 
		
	}
	
	@IBAction func buttonDimiss(sender: AnyObject) {
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
	@IBAction func dismiss(gesture: UISwipeGestureRecognizer) {
		switch gesture.direction {
		case UISwipeGestureRecognizerDirection.Down:
			presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
		default:
			break
		}
	}
	
	func translateToFloat(target: UITextField?, value: String, maxValue: CGFloat) -> CGFloat? {
		let max = Int(maxValue)
		if var intValue = value.toInt() {
//			intValue = intValue<0 ? 0 : intValue
//			intValue = intValue>max ? max : intValue
			if intValue < 0 {
				intValue = 0
				target?.text = "0"
			}
			if intValue > max {
				intValue = max
				target?.text = "\(max)"
			}
			return CGFloat(intValue) / maxValue
		}
		else {
			
			return nil
		}
	}
	
	func durationDidChange(notification: NSNotification) {
		if let changedThing = notification.object as? NumToColorSit {
			//let duration = changedThing.duration
			//durationSlider.value
			setDuration()
		}
	}
	
	func brightnessDidChange(notification: NSNotification) {
		if let changedThing = notification.object as? NumToColorSit {
			setBrightness()
		}
	}
	
//	func currentNumDidChange(notification: NSNotification) {
//		if let changedThing = notification.object as? NumToColorSit {
//			
//		}
//	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
}

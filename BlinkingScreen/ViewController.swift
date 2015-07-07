//
//  ViewController.swift
//  BlinkingScreen
//
//  Created by lunner on 3/24/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, RecordsDocumentDelegate {
	
	@IBOutlet var recordsPickerView: UIPickerView!
	@IBOutlet var numSequenceTextField: UITextField!
	@IBOutlet var colorSwitchView: UIView!
	
	
	@IBOutlet var doubleTap: UITapGestureRecognizer!
	
	//var records = [NumToColorSit]()
	var currentNumToColor: NumToColorSit?
	var document = RecordsDocument.document()
	
	var timer: NSTimer?
	var timeCount: Int = 1
	
	let numOfComponents = 1
	
	override func awakeFromNib() {
		super.awakeFromNib()
		document.delegate = self
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let userDefaults = NSUserDefaults.standardUserDefaults()
		document.currentRecordIndex = userDefaults.integerForKey(PreferenceKey.CurrentRecordIndexName.rawValue) //if not exists return 0
		//For this point the document's records is empty. because it is not loaded from disk
		configurePickerView()
		updateColorSwitchView()
		numSequenceTextField.text = document.currentNumToColor?.numSequence
		
		//doubleTap.addTarget(self, action: "previewColorSwich:")
		
		//document.getRecord(document.currentRecordIndex)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		// for now doucument .records still have 0 values
//		document.synchronizeCurrent()
//		configurePickerView()
//		updateColorSwitchView()
//		numSequenceTextField.text = document.currentNumToColor?.numSequence	
	}
	
	override func viewDidAppear(animated: Bool) {
		//still empty
//		let userDefaults = NSUserDefaults.standardUserDefaults()
//		document.currentRecordIndex = userDefaults.integerForKey(PreferenceKey.CurrentRecordIndexName.rawValue) //if not exists return 0
//		//For this point the document's records is empty. because it is not loaded from disk
//		configurePickerView()
//		updateColorSwitchView()
//		numSequenceTextField.text = document.currentNumToColor?.numSequence
//		document.getRecord(document.currentRecordIndex)
		super.viewDidAppear(animated)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "setNumToColor" {
			let controller = segue.destinationViewController as SetViewController
			controller.numToColor = document.currentNumToColor
		}
		
		if segue.identifier == "displayColors" {
			let controller = segue.destinationViewController as BlinkingScreenViewController
			controller.numToColor = document.currentNumToColor
		}
	}
	func configurePickerView() {
		recordsPickerView.showsSelectionIndicator = true
		
		//document.currentRecordIndex = document.records.count - 1
		//if !document.records.isEmpty {
			
		// MARK: set selected  row ( the currentNumToColor should last in records
		recordsPickerView.selectRow(document.currentRecordIndex, inComponent: 0, animated: true)
		//did need next?
		pickerView(recordsPickerView, didSelectRow: document.currentRecordIndex, inComponent: 0)
		
		//}
		
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	@IBAction func record() {
		// append to records and reload pickerview made it selected to last row
		//document.records.append(document.currentNumToColor!)
		document.appendToHistory(document.currentNumToColor!)
		
		recordsPickerView.selectRow(document.currentRecordIndex, inComponent: 0, animated: true)
		// MARK: next line is not needed?
		//pickerView(recordsPickerView, didSelectRow: document.currentRecordIndex, inComponent: 0)
	}
	
	@IBAction func clearRecords() {
		
	}
	// MARK: UIPickerviewDataSource
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return numOfComponents
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return document.records.count
	}
	
	// MARK: UIPickerViewDelegate
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// 
		if !document.records.isEmpty {
			let original = document.getRecord(row)
			// when scroll between two different rows below if code add row(should not add)
//			if !original.isEqualTo(document.currentNumToColor!) {
//				// append to history
//				document.appendToHistory(document.currentNumToColor!)
//				// MARK: reload OK?
//				recordsPickerView.reloadAllComponents() // reload
//			}
			document.currentRecordIndex = row
			//update numSequeenceTextfield and colorSwitchView
			let string = document.currentNumToColor?.numSequence

			numSequenceTextField.text = string 
			updateColorSwitchView(numSequence: string!)
		}
	}
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		if document.records.isEmpty {
			let string = "No records"
			return string
		}
		let string = document.records[row].numSequence
		return string
	}
	
	func isDigitalString(value: String) -> Bool {
//		for var i = 0; i < value.length; i++ {
//			if !isdigit(value.characterAtIndex(i)) {
//				return false
//			}
//		}
//		return true
		
//		var scan = NSScanner(string: value)
//		var val:UnsafeMutablePointer<Int>
//		return (scan.scanInt(val) && scan.atEnd() )
		
		
//		let regex: NSString = "[0-9]"
//		var predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//		if predicate.evaluateWithObject(value) {
//			return true
//		}
//		else {
//			return false
//		}
		
		for ch in value {
			switch ch {
			case "0","1","2","3","4","5","6","7","8","9":
				continue
			default:
				return false
			}
		}
		return true
		
	}
	
	@IBAction func numSequenceTextFieldEdited() {
		if let sequence = numSequenceTextField.text {
			if isDigitalString(sequence) {
				if document.currentNumToColor?.numSequence != sequence {
					document.currentNumToColor?.numSequence = sequence
					updateColorSwitchView(numSequence: sequence)
				}

			} else {
				let message = "Please input digital characters!"
				let alert = UIAlertController(title: "Could not extrat numbers", message: message, preferredStyle: .Alert)
				let okAction = UIAlertAction(title: "That's Sad", style: .Default, handler: nil)
				alert.addAction(okAction)
				presentViewController(alert, animated: true, completion: nil)
				//set back to original value
				numSequenceTextField.text = document.currentNumToColor?.numSequence 
			}
			
		} else {
			numSequenceTextField.backgroundColor = UIColor.whiteColor()
		}
	}
	
	func updateColorSwitchView(numSequence: NSString = "") {
		//set its background color to numSequence's fisrt num stand for
		if numSequence != "" {
			if let index = numSequence.substringToIndex(1).toInt() {
				let temp = document.currentNumToColor?.numToColors[index]
				let color = UIColor(red: temp!.R, green: temp!.G, blue: temp!.B, alpha: temp!.A)
				
				colorSwitchView.backgroundColor = color
			}
		}
		else {
			let string = NSString(string: document.currentNumToColor!.numSequence)
				
			if let  index = string.substringToIndex(1).toInt() {
				let temp = document.currentNumToColor?.numToColors[index]
				let color = UIColor(red: temp!.R, green: temp!.G, blue: temp!.B, alpha: temp!.A)
				
				colorSwitchView.backgroundColor = color
			}
			
		}
		
	}
	
	
	
	func updateBackgroundColor(aTimer: NSTimer) {
		let string = NSString(string: document.currentNumToColor!.numSequence)
		if timeCount >= string.length {
			timer?.invalidate()
			timeCount = 1
			return 
		}
		let index = characterToNum( string.characterAtIndex(timeCount) )
		let rawColor = document.currentNumToColor?.numToColors[index]
		let color = UIColor(red: rawColor!.R, green: rawColor!.G, blue: rawColor!.B, alpha: 1.0)
		colorSwitchView.backgroundColor = color
		colorSwitchView.setNeedsDisplay()
		++timeCount
	}
	
	@IBAction func previewColorSwitch(gesture: UITapGestureRecognizer) {
		let duration: NSTimeInterval = document.currentNumToColor!.duration
		timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: "updateBackgroundColor:", userInfo: nil, repeats: true)
		//let sequence = document.currentNumToColor?.numSequence 
		
//		for ch in sequence! {
//			let index = characterToNum(ch)
//			let rawColor = document.currentNumToColor?.numToColors[index]
//			let color = UIColor(red: rawColor!.R, green: rawColor!.G, blue: rawColor!.B, alpha: 1.0)
//			//colorSwitchView.backgroundColor = color 
//			//colorSwitchView.setNeedsDisplay()
//			
//			UIView.animateWithDuration(2.0, animations: {self.colorSwitchView.backgroundColor = color}, completion: nil)
//		}
	}
	
//	func restoreRecordsAndLastRecode()
//	{
//		
//		let userDefaults = NSUserDefaults.standardUserDefaults()
//		
//		if let records: AnyObject = userDefaults.objectForKey(PreferenceKey.Recodes.rawValue)  {
//			let re = records as [NumToColorSit]
//			self.records.removeAll(keepCapacity: false)
//			for record in re {
//				self.records.append(record as NumToColorSit)
//			}
//		}
//		
//		if let record = userDefaults.objectForKey(PreferenceKey.LastRecode.rawValue) as? NumToColorSit {
//			self.currentNumToColor = record 
//		} 
//	}
	
	func gotRecords() {
		recordsPickerView.reloadAllComponents()
	}
}

func characterToNum(ch: Character) -> Int {
	switch ch {
	case "0":
		return 0
	case "1":
		return 1
	case "2":
		return 2
	case "3":
		return 3
	case "4":
		return 4
	case "5":
		return 5
	case "6":
		return 6
	case "7":
		return 7
	case "8":
		return 8
	case "9":
		return 9
	default:
		return 0
	}
}

func characterToNum(ch: unichar) -> Int {
	return ch - 48 //'0' is 48
}


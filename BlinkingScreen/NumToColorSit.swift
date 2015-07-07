//
//  NumToColorSit.swift
//  BlinkingScreen
//
//  Created by lunner on 3/24/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import UIKit

let defaultR: CGFloat = 0.0
let defaultG: CGFloat = 0.0
let defaultB: CGFloat = 0.0
let defaultDuration: NSTimeInterval = 0.2 //ms
let defaultBrightness: CGFloat = 0.6 //0.0 - 1.0

class Color: NSObject, NSCoding {
	var R: CGFloat = 0.0
	var G: CGFloat = 0.0
	var B: CGFloat = 0.0
	var A: CGFloat = 1.0
	
	let RKey = "R"
	let GKey = "G"
	let BKey = "B"
	let AKey = "A"
	
	override init() {
		R = defaultR
		G = defaultG
		B = defaultB
		A = 1.0
	}
	init(another: Color) {
		self.R = another.R
		self.G = another.G
		self.B = another.B
		self.A = another.A
	}
	required init(coder decoder: NSCoder) {
		R = decoder.decodeObjectForKey(RKey) as CGFloat
		G = decoder.decodeObjectForKey(GKey) as CGFloat
		B = decoder.decodeObjectForKey(BKey) as CGFloat
		A = decoder.decodeObjectForKey(AKey) as CGFloat
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(R, forKey: RKey)
		aCoder.encodeObject(G, forKey: GKey)
		aCoder.encodeObject(B, forKey: BKey)
		aCoder.encodeObject(A, forKey: AKey)
	}
	
	func isEqualTo(another: Color) -> Bool {
		if (self.R == another.R) && (self.G == another.G) && (self.B == another.B) {
			return true
		}
		return false
	}
}
//struct GRB {
//	static let max: CGFloat = 255.0
//	static let min: CGFloat = 0.0
//}

let DurationChangedNotification = "DurationChangedNotification"
let BrightnessChangedNotification = "BrightnessChangedNotification"
let CurrentNumChangedNotification = "CurrentNumChangedNotification"

class NumToColorSit: NSObject, NSCoding {
	var numSequence: String
	var numToColors: [Color] = [Color]()
	var duration: NSTimeInterval {
		didSet {
			postDidChangeNotification(DurationChangedNotification)
		}
	}
	var brightness: CGFloat {
		didSet {
			postDidChangeNotification(BrightnessChangedNotification)
		}
	}
	
	var currentNum: Int = 0 //{
//		didSet {
//			// notification
//			postDidChangeNotification(CurrentNumChangedNotification)
//		}
//	}
	let numSequenceKey = "numSequence"
	let numToColorsKeys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	let durationKey = "duration"
	let brightnessKey = "brightness"
	let currentNumKey = "currentNum"
	
	required init(coder decoder: NSCoder) {
		numSequence = decoder.decodeObjectForKey(numSequenceKey) as String 
		for i in 0...9 {
			numToColors.append(decoder.decodeObjectForKey(numToColorsKeys[i]) as Color)
		}
		brightness = decoder.decodeObjectForKey(brightnessKey) as CGFloat
		duration = decoder.decodeObjectForKey(durationKey) as NSTimeInterval
		currentNum = decoder.decodeObjectForKey(currentNumKey) as Int
		
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(numSequence, forKey: numSequenceKey)
		for i in 0...9 {
			aCoder.encodeObject(numToColors[i], forKey: numToColorsKeys[i])
		}
		aCoder.encodeObject(brightness, forKey: brightnessKey)
		aCoder.encodeObject(duration, forKey: durationKey)
		aCoder.encodeObject(currentNum, forKey: currentNumKey)
	}
	
	override init() {
		self.numSequence = "0123456789"
		self.duration = defaultDuration
		self.brightness = defaultBrightness
		self.currentNum = 0
		
		for i in 0...9 {
			numToColors.append(Color())
		}
	}
	init(another: NumToColorSit) {
		self.numSequence = another.numSequence
		//self.numToColors = another.numToColors
		self.numToColors.removeAll(keepCapacity: true)
		for i in 0...9 {
			self.numToColors.append(Color(another: another.numToColors[i]))
		}
		self.brightness = another.brightness
		self.currentNum = another.currentNum
		self.duration = another.duration
	}
	init(numSequence: String, colors: [Color]?, duration: NSTimeInterval, brightness: CGFloat)
	{
		self.numSequence = numSequence
		self.duration = duration
		
		self.brightness = brightness
		
		self.currentNum = 0
		
		if colors != nil {
			if colors?.count < 10 {
				//num of color not accepted Do notification? 
				print("Init NumToColorSit: colors's count not enough!")
			}
			for i in 0...9 {
				//numToColors[i] = colors![i]
				numToColors.append(colors![i])
			}
		} else {
			for i in 0...9 {
				numToColors.append(Color())
			}
		}
	}
	
	func postDidChangeNotification(name: String) {
		let center = NSNotificationCenter.defaultCenter()
		center.postNotificationName(name , object: self)
	}
	
	func isEqualTo(another: NumToColorSit) -> Bool {
		if ((self.numSequence == another.numSequence) && (self.brightness == another.brightness) && (self.duration == another.duration) ) {
			for i in 0...9 {
				if !self.numToColors[i].isEqualTo(self.numToColors[i]) {
					return false
				}
			}
			return true
		} else {
			return false
		}
	}
	
	func setDefaultsAtNumWithoutNumSequence(num: Int) {
		self.duration = defaultDuration
		self.brightness = defaultBrightness
		self.numToColors[num].R = defaultR
		self.numToColors[num].G = defaultG
		self.numToColors[num].B = defaultB
	}
	
}
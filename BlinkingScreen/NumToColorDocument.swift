//
//  NumToColorDocument.swift
//  BlinkingScreen
//
//  Created by lunner on 3/26/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import UIKit

protocol RecordsDocumentDelegate {
	func gotRecords()
}
enum PreferenceKey: String {
	case RecordsDocumentName =  "Num to Color.sit"
	case RecordsPreferredName = "numColors.data"
	case CurrentRecordIndexName = "CurrentRecordIndex.data"
}


class RecordsDocument: UIDocument {
	var isJustLoaded = true
	var delegate: RecordsDocumentDelegate?
	
	var docWrapper = NSFileWrapper(directoryWithFileWrappers: [:])
	var records = [NumToColorSit]()
	var currentRecordIndex: Int = -1 {
		didSet {
			//assert(newvalue >= -1 && newvalue<records.count, "currentRecord: index out of bounds")
			// test whether changed if changed append currentNumToColor to records and call synchronizeCurrent
			if isJustLoaded {
				updateChangeCount(.Done)
				isJustLoaded = false
			}
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setInteger(currentRecordIndex, forKey: PreferenceKey.CurrentRecordIndexName.rawValue)
			self.synchronizeCurrent()
		}
	}
	var currentNumToColor: NumToColorSit?
	var recordsCount: Int {
		return records.count
	} 
	
	class var documentURL: NSURL {
		let fileManager = NSFileManager.defaultManager()
		if let documentsDirURL = fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil) {
			return documentsDirURL.URLByAppendingPathComponent(PreferenceKey.RecordsDocumentName.rawValue)
		}
		assertionFailure("Unable to determine document storage location")
	}
	
	class func document(atURL url: NSURL = RecordsDocument.documentURL) -> RecordsDocument {
		let fileManager = NSFileManager.defaultManager()
		var document = RecordsDocument(fileURL: RecordsDocument.documentURL) 
		if fileManager.fileExistsAtPath(url.path!) {
			document.openWithCompletionHandler( {
				(success) in
				if success {
					//document.delegate?.gotRecords()
				}
			})
		} else { 
			document.saveToURL(url, forSaveOperation: .ForCreating, completionHandler: nil)
		}
	
		return document
		assertionFailure("Unabe to create ThingsDocument for \(url)")
	}
	
	override func contentsForType(typeName: String, error outError: NSErrorPointer) -> AnyObject? {
		if let wrapper = docWrapper.fileWrappers[PreferenceKey.RecordsPreferredName.rawValue] as? NSFileWrapper {
			docWrapper.removeFileWrapper(wrapper)
		}
		let colorsData = NSKeyedArchiver.archivedDataWithRootObject(records)
		docWrapper.addRegularFileWithContents(colorsData, preferredFilename: PreferenceKey.RecordsPreferredName.rawValue)
		
//		let userDefaults = NSUserDefaults.standardUserDefaults()
//		userDefaults.setInteger(currentRecord, forKey: PreferenceKey.CurrentRecordIndexName.rawValue)
//		
		return docWrapper
	}
	
	override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		if let contentWrapper = contents as? NSFileWrapper {
			if let recordsWrapper = contentWrapper.fileWrappers[PreferenceKey.RecordsPreferredName.rawValue] as? NSFileWrapper {
				if let data = recordsWrapper.regularFileContents {
					records = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [NumToColorSit]
					docWrapper = contentWrapper
					
//					let userDefaults = NSUserDefaults.standardUserDefaults()
//					
//					currentRecord = userDefaults.integerForKey(PreferenceKey.CurrentRecordIndexName.rawValue) 
					
					return true
				}
			}
		}
		return false
	}
	
//	func getCurrent() -> NumToColorSit {
//		if currentRecord < recordsCount && currentRecord >= 0 {
//			return NumToColorSit(another: records[currentRecord]) //return a copy
//		} else {
//			return NumToColorSit()
//		}
//	}
	
	
	func synchronizeCurrent() {
		if !records.isEmpty {
			currentNumToColor = NumToColorSit(another: records[currentRecordIndex])
		} else {
			currentNumToColor = NumToColorSit()
		}
	}
	
	func appendToHistory(current: NumToColorSit) {
		records.append(current)
		self.delegate?.gotRecords()
		self.currentRecordIndex = records.count - 1
		updateChangeCount(.Done)
	}
	func getRecord(index: Int) -> NumToColorSit {
		return records[index]
	}
	func removeRecord(index: Int) {
		records.removeAtIndex(index)
		updateChangeCount(.Done)
	}
	func clearRecords() {
		records.removeAll(keepCapacity: false)
		updateChangeCount(.Done)
	}
}

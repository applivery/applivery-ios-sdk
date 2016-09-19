//
//  Json.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 14/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


class JSON: CustomStringConvertible {

	var description: String {
		if let data = try! JSONSerialization.data(withJSONObject: self.json, options: .prettyPrinted) as Data? {
			if let description = String(data: data, encoding: String.Encoding.utf8) {
				return description
			}
			else {
				return self.json.description
			}
		}
		else {
			return self.json.description
		}
	}
	
	fileprivate var json: AnyObject
	
	
	// MARK - Initializers
	
	init(json: AnyObject) {
		self.json = json
	}
	
	subscript(path: String) -> JSON? {
		get {
			guard var jsonDict = self.json as? [String: AnyObject] else {
				return nil
			}

			var json = self.json
			let pathArray = path.components(separatedBy: ".")
			
			for key in pathArray {
				
				if let jsonObject = jsonDict[key] {
					json = jsonObject
					
					if let jsonDictNext = jsonObject as? [String : AnyObject] {
						jsonDict = jsonDictNext
					}
				}
				else {
					return nil
				}
			}
			
			return JSON(json: json)
		}
	}
	
	class func dataToJson(_ data: Data) throws -> JSON {
		let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
		let json = JSON(json: jsonObject as AnyObject)
		
		return json
	}
	
	
	// MARK - Public methods
	
	func toData() -> Data? {
		do {
			let data = try JSONSerialization.data(withJSONObject: self.json, options:.prettyPrinted)
			return data
		}
		catch let error as NSError {
			LogError(error)
			return nil
		}
	}
	
	func toBool() -> Bool? {
		return self.json as? Bool
	}
	
	
	func toInt() -> Int? {
		return self.json as? Int
	}
	
	
	func toString() -> String? {
		return self.json as? String
	}
}


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
		if let data = try! NSJSONSerialization.dataWithJSONObject(self.json, options: .PrettyPrinted) as NSData? {
			if let description = String(data: data, encoding: NSUTF8StringEncoding) {
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
	
	private var json: AnyObject
	
	
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
			let pathArray = path.componentsSeparatedByString(".")
			
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
	
	class func dataToJson(data: NSData) throws -> JSON {
		let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
		let json = JSON(json: jsonObject)
		
		return json
	}
	
	
	// MARK - Public methods
	
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


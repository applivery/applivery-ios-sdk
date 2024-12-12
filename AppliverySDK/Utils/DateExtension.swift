//
//  DateExtension.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 10/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

let kDateISOFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

extension Date {
	static func date(from string: String, format: String = kDateISOFormat) -> Date? {
		let dateFormat = DateFormatter()
		dateFormat.dateFormat = format
		
		let date = dateFormat.date(from: string)
		return date
	}
	
	static func today() -> Date {
		return Date()
	}
}

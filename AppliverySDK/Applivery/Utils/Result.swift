//
//  Result.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 23/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


enum Result<SuccessType: Equatable, ErrorType: Equatable>: Equatable {
	case success(SuccessType)
	case error(ErrorType)
}

func ==<S: Equatable, E: Equatable> (left: Result<S, E>, right: Result<S, E>) -> Bool {
	switch (left, right) {
	case (.success(let lValue), .success(let rValue))	where lValue == rValue: return true
	case (.error(let lError), .error(let rError))		where lError == rError: return true
	default: return false
	}
}

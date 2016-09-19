//
//  UpdateViewMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 8/12/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class UpdateViewMock: UpdateView {
	
	// OUTPUTS
	var outShowUpdateMessage = (called: false, message: "")
	var outShowLoadingCalled = false
	var outStopLoadingCalled = false
	var outShowErrorMessage = (called: false, message: "")
	
	
	func showUpdateMessage(_ message: String) {
		self.outShowUpdateMessage = (true, message)
	}
	
	func showLoading(){
		self.outShowLoadingCalled = true
	}
	
	func stopLoading(){
		self.outStopLoadingCalled = true
	}
	
	func showErrorMessage(_ message: String){
		self.outShowErrorMessage = (true, message)
	}

}

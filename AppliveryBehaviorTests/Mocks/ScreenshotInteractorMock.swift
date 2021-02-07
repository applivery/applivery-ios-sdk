//
//  ScreenshotInteractorMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/4/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class ScreenshotInteractorMock: PScreenshotInteractor {

	var fakeScreenshot: Screenshot!

	func getScreenshot() -> Screenshot {
		return self.fakeScreenshot
	}

}

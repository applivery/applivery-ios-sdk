//
//  Configurator.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 20/03/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation

struct Configurator {
	
	static func loginInteractor() -> LoginInteractor {
		return LoginInteractor(
			app: App(),
			loginDataManager: LoginDataManager(
				loginService: LoginService()
			),
			globalConfig: GlobalConfig.shared,
			sessionPersister: SessionPersister(
				userDefaults: UserDefaults.standard
			)
		)
	}
	
	static func updateInteractor() -> UpdateInteractor {
		return UpdateInteractor(
			output: nil,
            configService: ConfigService(),
			downloadData: DownloadDataManager(),
			app: App(),
			loginInteractor: Configurator.loginInteractor(),
			globalConfig: GlobalConfig.shared
		)
	}
	
//	static func feedbackInteractor() -> FeedbackInteractor {
//		return FeedbackInteractor(
//			service: FeedbackService(
//				app: App(),
//				device: Device(),
//				config: GlobalConfig.shared
//			),
//			configDataManager: ConfigDataManager(),
//			loginInteractor: Configurator.loginInteractor()
//		)
//	}
	
	static func screenshotInteractor() -> ScreenshotInteractor {
		return ScreenshotInteractor(
			imageManager: ImageManager()
		)
	}
	
}

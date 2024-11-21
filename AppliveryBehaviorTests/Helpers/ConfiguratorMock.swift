//
//  ConfiguratorMock.swift
//  AppliveryBehaviorTests
//
//  Created by Alejandro Jiménez Agudo on 29/10/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery

struct ConfiguratorMock {
	
	let appMock: AppMock
	let userDefaultsMock: UserDefaultsMock
	let globalConfig: GlobalConfig
	let eventDetectorMock: EventDetectorMock
	
	func applivery() -> Applivery {
		return Applivery(
			startInteractor: self.startInteractor(),
            globalConfig: globalConfig,
			updateCoordinator: self.updateCoordinator(),
			updateInteractor: self.updateInteractor(),
			feedbackCoordinator: self.feedbackCoordinator(),
            loginInteractor: self.loginInteractor(),
            environments: self.environment()
		)
	}
    
    func environment() -> EnvironmentProtocol {
        return MockEnvironments()
    }
	
	func startInteractor() -> StartInteractor {
		return StartInteractor(
			configDataManager: self.configDataManager(),
			globalConfig: globalConfig,
			eventDetector: eventDetectorMock,
			sessionPersister: self.sessionPersister(),
			updateInteractor: self.updateInteractor()
		)
	}
	
	func loginInteractor() -> LoginInteractor {
		return LoginInteractor(
			app: appMock,
			loginDataManager: self.loginDataManager(),
			globalConfig: globalConfig,
			sessionPersister: self.sessionPersister()
		)
	}
	
	func updateInteractor() -> UpdateInteractor {
		return UpdateInteractor(
			output: nil,
			configData: self.configDataManager(),
			downloadData: self.downloadDataManager(),
			app: appMock,
			loginInteractor: self.loginInteractor(),
			globalConfig: globalConfig
		)
	}
	
	func updateCoordinator() -> UpdateCoordinator {
		return UpdateCoordinator(
			updateInteractor: self.updateInteractor(),
			app: appMock
		)
	}
	
	func feedbackCoordinator() -> PFeedbackCoordinator {
		return FeedbackCoordinator(
			app: appMock
		)
	}
	
	func configDataManager() -> PConfigDataManager {
		return ConfigDataManager(
			appInfo: appMock,
			configPersister: self.configPersister(),
			configService: ConfigService()
		)
	}
	
	func downloadDataManager() -> PDownloadDataManager {
		return DownloadDataManager(
			service: DownloadService()
		)
	}
	
	func loginDataManager() -> LoginDataManager {
		return LoginDataManager(
			loginService: LoginService()
		)
	}
	
	func sessionPersister() -> SessionPersister {
		return SessionPersister(
			userDefaults: userDefaultsMock
		)
	}
	
	func configPersister() -> ConfigPersister {
		return ConfigPersister(
			userDefaults: userDefaultsMock
		)
	}
	
}

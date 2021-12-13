//
//  File.swift
//  
//
//  Created by Alejandro Jiménez on 13/12/21.
//

import Foundation
@testable import Applivery

struct TestBuilder {
    
    // MARK: - Presenters
    
    static func feedbackPresenter(view: FeedbackViewMock, app: AppMock, device: DeviceMock, config: GlobalConfig, userDefaults: UserDefaultsMock, feedbackCoordinator: FeedbackCoordinator, imageManager: ImageManagerMock) -> FeedbackPresenter {
        FeedbackPresenter(
            view: view,
            feedbackInteractor: Self.feedbackInteractor(
                app: app,
                device: device,
                config: config,
                userDefaults: userDefaults),
            feedbackCoordinator: feedbackCoordinator,
            screenshotInteractor: ScreenshotInteractor(
                imageManager: imageManager
            )
        )
    }
    
    // MARK: - Interactors
    
    static func feedbackInteractor(app: AppMock, device: DeviceMock, config: GlobalConfig, userDefaults: UserDefaultsMock) -> FeedbackInteractor {
        FeedbackInteractor(
            service: FeedbackService(
                app: app,
                device: device,
                config: config),
            configDataManager: Self.configDataManager(
                app: app,
                userDefaults: userDefaults),
            loginInteractor: Self.loginInteractor(
                app: app,
                config: config,
                userDefaults: userDefaults
            )
        )
    }
    
    static func loginInteractor(app: AppMock, config: GlobalConfig, userDefaults: UserDefaultsMock) -> LoginInteractor {
        LoginInteractor(
            app: app,
            loginDataManager: LoginDataManager(
                loginService: LoginService()),
            globalConfig: config,
            sessionPersister: SessionPersister(
                userDefaults: userDefaults
            )
        )
    }
    
    // MARK: - Data Managers
    
    static func configDataManager(app: AppMock, userDefaults: UserDefaultsMock) -> ConfigDataManager {
        ConfigDataManager(
            appInfo: app,
            configPersister: ConfigPersister(
                userDefaults: userDefaults),
            configService: ConfigService()
        )
    }
    
}

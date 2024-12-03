//
//  StartInteractor.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


protocol StartInteractorOutput {
    func forceUpdate()
    func otaUpdate()
    func feedbackEvent()
    func credentialError(message: String)
}

class StartInteractor {
        
    private let app: AppProtocol
    private let configService: ConfigServiceProtocol
    private let globalConfig: GlobalConfig
    private let eventDetector: EventDetector
    private let sessionPersister: SessionPersister
    private let updateService: UpdateServiceProtocol
    
    // MARK: Initializers
    
    init(
        app: AppProtocol = App(),
        configService: ConfigServiceProtocol = ConfigService(),
        globalConfig: GlobalConfig = GlobalConfig.shared,
        eventDetector: EventDetector = ScreenshotDetector(),
        sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard),
        updateService: UpdateServiceProtocol = UpdateService()
    ) {
        self.app = app
        self.configService = configService
        self.globalConfig = globalConfig
        self.eventDetector = eventDetector
        self.sessionPersister = sessionPersister
        self.updateService = updateService
    }
    
    
    // MARK: Internal Methods
    
    func start() {
        logInfo("Applivery is starting... ")
        logInfo("SDK Version: \(GlobalConfig.shared.app.getSDKVersion())")
        guard !self.globalConfig.appToken.isEmpty else {
            return //self.output.credentialError(message: kLocaleErrorEmptyCredentials)
        }
        self.eventDetector.listenEvent(app.presentFeedbackForm)
        self.updateConfig()
    }
    
    func disableFeedback() {
        guard self.globalConfig.feedbackEnabled else { return }
        
        self.globalConfig.feedbackEnabled = false
        self.eventDetector.endListening()
    }
    
    // MARK: Private Methods
    
    private func updateConfig() {
        self.globalConfig.accessToken = self.sessionPersister.loadAccessToken()
        Task {
            do {
                let updateConfig = try await configService.updateConfig()
                self.checkUpdate(for: updateConfig)
            } catch {
                //self.output.credentialError(message: "Credentials are invalid.")
                let currentConfig = self.configService.getCurrentConfig()
                self.checkUpdate(for: currentConfig)
            }
        }
    }
    
    private func checkUpdate(for updateConfig: UpdateConfigResponse) {
        if self.updateService.checkForceUpdate(updateConfig.config, version: updateConfig.version) {
            updateService.forceUpdate()
        } else if self.updateService.checkOtaUpdate(updateConfig.config, version: updateConfig.version) {
            updateService.otaUpdate()
        }
    }
    
}

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
    
    var output: StartInteractorOutput!
    
    private let configService: ConfigServiceProtocol
    private let globalConfig: GlobalConfig
    private let eventDetector: EventDetector
    private let sessionPersister: SessionPersister
    private let updateInteractor: PUpdateInteractor
    
    // MARK: Initializers
    
    init(
        configService: ConfigServiceProtocol = ConfigService(),
        globalConfig: GlobalConfig = GlobalConfig.shared,
        eventDetector: EventDetector = ScreenshotDetector(),
        sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard),
        updateInteractor: PUpdateInteractor = Configurator.updateInteractor()
    ) {
        self.configService = configService
        self.globalConfig = globalConfig
        self.eventDetector = eventDetector
        self.sessionPersister = sessionPersister
        self.updateInteractor = updateInteractor
    }
    
    
    // MARK: Internal Methods
    
    func start() {
        logInfo("Applivery is starting... ")
        logInfo("SDK Version: \(GlobalConfig.shared.app.getSDKVersion())")
        guard !self.globalConfig.appToken.isEmpty else {
            return self.output.credentialError(message: kLocaleErrorEmptyCredentials)
        }
        self.eventDetector.listenEvent(self.output.feedbackEvent)
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
                self.output.credentialError(message: "Credentials are invalid.")
                let currentConfig = self.configService.getCurrentConfig()
                self.checkUpdate(for: currentConfig)
            }
        }
    }
    
    private func checkUpdate(for updateConfig: UpdateConfigResponse) {
        if self.updateInteractor.checkForceUpdate(updateConfig.config, version: updateConfig.version) {
            self.output.forceUpdate()
        } else if self.updateInteractor.checkOtaUpdate(updateConfig.config, version: updateConfig.version) {
            self.output.otaUpdate()
        }
    }
    
}

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
    
    private let configDataManager: PConfigDataManager
    private let globalConfig: GlobalConfig
    private let eventDetector: EventDetector
    private let sessionPersister: SessionPersister
    
    
    // MARK: Initializers
    
    init(configDataManager: PConfigDataManager = ConfigDataManager(),
         globalConfig: GlobalConfig = GlobalConfig.shared,
         eventDetector: EventDetector = ScreenshotDetector(),
         sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard)
        ) {
        self.configDataManager = configDataManager
        self.globalConfig = globalConfig
        self.eventDetector = eventDetector
        self.sessionPersister =  sessionPersister
    }
    
    
    // MARK: Internal Methods
    
    func start() {
        logInfo("Applivery is starting... ")
        logInfo("SDK Version: \(GlobalConfig.SDKVersion)")
        guard !self.globalConfig.appToken.isEmpty
            else { return self.output.credentialError(message: kLocaleErrorEmptyCredentials) }
        
        self.eventDetector.listenEvent(self.output.feedbackEvent)
        
        guard !self.globalConfig.appStoreRelease else {
            return logWarn("The build is marked like an AppStore Release. Applivery won't present any update message to the user")
        }
        
        self.updateConfig()
    }
    
    func disableFeedback() {
        guard self.globalConfig.feedbackEnabled else { return }
        
        self.globalConfig.feedbackEnabled = false
        self.eventDetector.endListening()
    }
    
    
    // MARK: Private Methods
    
    fileprivate func updateConfig() {
        self.globalConfig.accessToken = self.sessionPersister.loadAccessToken()
        self.configDataManager.updateConfig { response in
            switch response {
            case .success(let configResponse):
                if !self.checkForceUpdate(configResponse.config, version: configResponse.version) {
                    self.checkOtaUpdate(configResponse.config, version: configResponse.version)
                }
            case .error(let error):
                self.output.credentialError(message: error.message())
                let currentConfig = self.configDataManager.getCurrentConfig()
                if !self.checkForceUpdate(currentConfig.config, version: currentConfig.version) {
                    self.checkOtaUpdate(currentConfig.config, version: currentConfig.version)
                }
            }
        }
    }
    
    private func checkForceUpdate(_ config: Config?, version: String) -> Bool {
        guard
            let minVersion = config?.minVersion,
            let forceUpdate = config?.forceUpdate,
            forceUpdate
            else { return false }
        
        logInfo("Checking if app version: \(version) is older than minVersion: \(minVersion)")
        if self.isOlder(version, minVersion: minVersion) {
            self.output.forceUpdate()
            return true
        }
        
        return false
    }
    
    private func checkOtaUpdate(_ config: Config?, version: String) {
        guard
            let lastVersion = config?.lastVersion,
            let otaUpdate = config?.otaUpdate,
            otaUpdate
            else { return }
        
        logInfo("Checking if app version: \(version) is older than last build version: \(lastVersion)")
        if self.isOlder(version, minVersion: lastVersion) {
            self.output.otaUpdate()
        }
    }
    
    private func isOlder(_ currentVersion: String, minVersion: String) -> Bool {
        let (current, min) = self.equalLengthFillingWithZeros(left: currentVersion, right: minVersion)
        let result = current.compare(min, options: NSString.CompareOptions.numeric, range: nil, locale: nil)
        
        return result == ComparisonResult.orderedAscending
    }
    
    fileprivate func equalLengthFillingWithZeros(left: String, right: String) -> (String, String) {
        let componentsLeft = left.components(separatedBy: ".")
        let componentsRight = right.components(separatedBy: ".")
        
        if componentsLeft.count == componentsRight.count {
            return (left, right)
        } else if componentsLeft.count < componentsRight.count {
            let dif = componentsRight.count - componentsLeft.count
            let leftFilled = self.fillWithZeros(string: componentsLeft, length: dif)
            return (leftFilled, right)
        } else {
            let dif = componentsLeft.count - componentsRight.count
            let rightFilled = self.fillWithZeros(string: componentsRight, length: dif)
            return (left, rightFilled)
        }
    }
    
    fileprivate func fillWithZeros(string: [String], length: Int) -> String {
        var zeroFilledString = string
        for _ in 1...length {
            zeroFilledString.append("0")
        }
        
        return zeroFilledString.joined(separator: ".")
    }
}

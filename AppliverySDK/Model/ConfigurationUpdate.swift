//
//  File.swift
//  Applivery
//
//  Created by Fran Alarza on 8/4/25.
//

import Foundation

@objcMembers
public class AppliveryConfiguration: NSObject {
    public let postponedTimeFrames: [TimeInterval]
    public let enforceAuthentication: Bool
    public var postponeUpdateUntil: Date? = nil

    public init(
        postponedTimeFrames: [TimeInterval] = [],
        enforceAuthentication: Bool = false,
        postponeUpdateUntil: Date?
    ) {
        self.postponedTimeFrames = postponedTimeFrames
        self.enforceAuthentication = enforceAuthentication
        self.postponeUpdateUntil = postponeUpdateUntil
    }

    @objc(initWithPostponedTimeFramesNSNumber:enforceAuthentication:postponeUpdateUntil:)
    public convenience init(
        postponedTimeFrames nsNumbers: [NSNumber],
        enforceAuthentication: Bool,
        postponeUpdateUntil: Date?
    ) {
        self.init(
            postponedTimeFrames: nsNumbers.map { $0.doubleValue },
            enforceAuthentication: enforceAuthentication,
            postponeUpdateUntil: postponeUpdateUntil
        )
    }
}

extension AppliveryConfiguration {
    public static var empty: AppliveryConfiguration {
        .init(postponeUpdateUntil: nil)
    }
}

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

    public init(
        postponedTimeFrames: [TimeInterval] = [],
        enforceAuthentication: Bool = false
    ) {
        self.postponedTimeFrames = postponedTimeFrames
        self.enforceAuthentication = enforceAuthentication
    }

    @objc(initWithPostponedTimeFramesNSNumber:enforceAuthentication:)
    public convenience init(
        postponedTimeFrames nsNumbers: [NSNumber],
        enforceAuthentication: Bool
    ) {
        self.init(
            postponedTimeFrames: nsNumbers.map { $0.doubleValue },
            enforceAuthentication: enforceAuthentication
        )
    }
}
extension AppliveryConfiguration {
    public static let empty = AppliveryConfiguration()
}

//
//  File.swift
//  Applivery
//
//  Created by Fran Alarza on 8/4/25.
//

import Foundation

public class AppliveryConfiguration: NSObject {
    let postponedTimeFrames: [TimeInterval]
    
    public init(postponedTimeFrames: [TimeInterval] = []) {
        self.postponedTimeFrames = postponedTimeFrames
    }
}

extension AppliveryConfiguration {
    public static let empty = AppliveryConfiguration()
}

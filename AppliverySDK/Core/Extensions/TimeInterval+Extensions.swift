//
//  TimeInterval+Extensions.swift
//  Applivery
//
//  Created by Fran Alarza on 8/4/25.
//

import Foundation

extension TimeInterval {
    
    var formatTimeInterval: String {
        switch self {
        case ..<60:
            return "\(Int(self)) seconds"
        case 60..<(60 * 60):
            let minutes = Int(self / 60)
            return "\(minutes) minute" + (minutes > 1 ? "s" : "")
        case (60 * 60)..<(60 * 60 * 24):
            let hours = Int(self / (60 * 60))
            return "\(hours) hour" + (hours > 1 ? "s" : "")
        default:
            let days = Int(self / (60 * 60 * 24))
            return "\(days) day" + (days > 1 ? "s" : "")
        }
    }
}


//
//  MockEventDetector.swift
//  Applivery
//
//  Created by Fran Alarza on 5/12/24.
//

import UIKit
@testable import Applivery

class MockEventDetector: EventDetector {
    
    var isListening = false
    var onDetection: (() -> Void)?
    
    func listenEvent(_ onDetection: @escaping () -> Void) {
        isListening = true
        self.onDetection = onDetection
    }
    
    func endListening() {
        isListening = false
        onDetection = nil
    }
    
    func simulateEvent() {
        guard isListening else {
            print("Event detection is not active. Call listenEvent before simulating events.")
            return
        }
        onDetection?()
    }
}

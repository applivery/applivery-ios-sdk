//
//  ScreenshootViewModel.swift
//
//
//  Created by Fran Alarza on 11/9/24.
//

import Foundation
import UIKit
import SwiftUI

final class ScreenshootViewModel {
    
    private let feedbackService: PFeedbackService
    
    init(
        feedbackService: PFeedbackService = FeedbackService(
            app: App(),
            device: Device(),
            config: GlobalConfig.shared
        )
    ) {
        self.feedbackService = feedbackService
    }
    
    func sendScreenshootFeedback(feedback: Feedback) {
        feedbackService.postFeedback(feedback) { result in
            switch result {
            case .success(let successType):
                print("Feedback sended succesfully")
            case .error(let errorType):
                print("Feedback sended error:")
            }
        }
    }
}

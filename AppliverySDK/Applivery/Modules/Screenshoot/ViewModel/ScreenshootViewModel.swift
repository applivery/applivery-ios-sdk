//
//  ScreenshootViewModel.swift
//
//
//  Created by Fran Alarza on 11/9/24.
//

import Foundation

final class ScreenshootViewModel {
    
    private let feedbackService: PFeedbackService
    
    init(feedbackService: PFeedbackService) {
        self.feedbackService = feedbackService
    }
    
    func sendScreenshootFeedback(feedback: Feedback) {
        feedbackService.postFeedback(feedback) { result in
            //
        }
    }
}

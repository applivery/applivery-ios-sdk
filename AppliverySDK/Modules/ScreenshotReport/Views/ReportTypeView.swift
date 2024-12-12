//
//  ReportTypeView.swift
//
//
//  Created by Fran Alarza on 12/9/24.
//

import SwiftUI

struct ReportTypeView: View {
    @Binding var reportType: FeedbackType
    
    var body: some View {
        Picker("Select Type", selection: $reportType) {
            Text(literal(.feedbackTypeFeedback) ?? "").tag(FeedbackType.feedback)
            Text(literal(.feedbackTypeBug) ?? "").tag(FeedbackType.bug)
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    ReportTypeView(reportType: .constant(.bug))
}

//
//  ScreenshootPreview.swift
//
//
//  Created by Fran Alarza on 10/9/24.
//

import SwiftUI

struct ScreenshootPreviewScreen: View {
    @Environment(\.dismiss) var dismiss
    @State var screenshot: UIImage?
    @State var user: String = ""
    @State var description: String = ""
    @State var selectionType: FeedbackType = .feedback
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Divider()
                reportType
                Divider()
                userThatReports
                Divider()
                TextEditor(text: $description)
                    .frame(maxHeight: .infinity)
                    .lineLimit(0)
                ScreenShootRowView(image: $screenshot)
                    .frame(height: 64)
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Send \(selectionType.rawValue.capitalized)")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss.callAsFunction()
                    }, label: {
                        Text("X")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss.callAsFunction()
                    }, label: {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(10))
                    })
                }
            })
        }
    }
    
    var reportType: some View {
        Picker("Select Type", selection: $selectionType) {
            Text(literal(.feedbackTypeFeedback) ?? "").tag(FeedbackType.feedback)
            Text(literal(.feedbackTypeBug) ?? "").tag(FeedbackType.bug)
        }
        .pickerStyle(.segmented)
    }
    
    var userThatReports: some View {
        HStack(spacing: 16) {
            Text("From:")
            TextField("Introduce your email", text: $user)
                .disabled(!user.isEmpty)
            Spacer()
        }
    }
}

#Preview {
    ScreenshootPreviewScreen(screenshot: UIImage(systemName: "figure.walk") ?? UIImage())
}

#Preview("Disabled user TextField") {
    ScreenshootPreviewScreen(screenshot: UIImage(systemName: "figure.walk") ?? UIImage(), user: "paquito@gmail.com")
}

//
//  ScreenshootPreview.swift
//
//
//  Created by Fran Alarza on 10/9/24.
//

import SwiftUI

struct ScreenshootPreviewScreen: View {
    let viewModel = ScreenshootViewModel()
    @Environment(\.dismiss) var dismiss
    @State var screenshot: UIImage?
    @State var user: String = ""
    @State var description: String = ""
    @State var reportType: FeedbackType = .feedback
    @State var imageLines: [Line] = []
    @FocusState var focused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Divider()
                ReportTypeView(reportType: $reportType)
                Divider()
                EmailTextFieldView(user: $user) {
                    focused = true
                }
                Divider()
                TextEditor(text: $description)
                    .frame(maxHeight: .infinity)
                    .lineLimit(0)
                    .focused($focused)
                ScreenShootRowView(image: $screenshot, lines: $imageLines)
                    .frame(height: 64)
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Send \(reportType.rawValue.capitalized)")
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

                    }, label: {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(10))
                    })
                }
            })
        }
    }
}

#Preview {
    ScreenshootPreviewScreen(screenshot: UIImage(systemName: "figure.walk") ?? UIImage())
}

#Preview("Disabled user TextField") {
    ScreenshootPreviewScreen(screenshot: UIImage(systemName: "figure.walk") ?? UIImage(), user: "paquito@gmail.com")
}

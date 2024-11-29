//
//  VideoPreviewScreen.swift
//
//
//  Created by Fran Alarza on 12/9/24.
//

import SwiftUI

struct VideoPreviewScreen: View {
    @StateObject var viewModel = ScreenshootViewModel()
    @Environment(\.dismiss) var dismiss
    @State var url: URL?
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
                .disabled(!viewModel.loadUserName().isEmpty)
                Divider()
                TextEditor(text: $description)
                    .overlay(alignment: .topLeading, content: {
                        if description.isEmpty {
                            Text("Type Here ...")
                                .foregroundColor(.gray)
                                .padding(.top, 6)
                        }
                    })
                    .frame(maxHeight: .infinity)
                    .lineLimit(0)
                    .focused($focused)
                Spacer()
                VideoPreviewRow(videoURL: $url)
                    .frame(height: 64)
            }
            .alert(viewModel.isReportSended.title ?? "", isPresented: $viewModel.isAlertPresented, actions: {
                Button(action: {
                    dismiss.callAsFunction()
                }, label: {
                    Text("Ok")
                })
            })
            .onAppear(perform: {
                user = viewModel.loadUserName()
            })
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
                        viewModel.sendVideoFeedback(feedback: .init(feedbackType: reportType, message: description, screenshot: nil, videoURL: url))
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
    VideoPreviewScreen()
}

//
//  VideoPreviewScreen.swift
//
//
//  Created by Fran Alarza on 12/9/24.
//

import SwiftUI

struct VideoPreviewScreen: View {
    @ObservedObject var viewModel = ScreenshootViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var url: URL?
    @State var user: String = ""
    @State var description: String = ""
    @State var reportType: FeedbackType = .feedback
    @State var imageLines: [Line] = []
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Divider()
                ReportTypeView(reportType: $reportType)
                Divider()
                EmailTextFieldView(user: $user) {
                    // Removed focus state since it's iOS15+
                    // If you need to do something on submit, handle here.
                }
                .disabled(!viewModel.loadUserName().isEmpty)
                Divider()
                
                ZStack(alignment: .topLeading) {
                    MultilineTextView(text: $description)
                        .frame(maxHeight: .infinity)
                    if description.isEmpty {
                        Text("Type Here ...")
                            .foregroundColor(.gray)
                            .padding(.top, 6)
                            .padding(.leading, 4)
                    }
                }
                
                Spacer()
                VideoPreviewRow(videoURL: $url)
                    .frame(height: 64)
            }
            .padding()
            .navigationBarTitle("Send \(reportType.rawValue.capitalized)")
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("X")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }),
                trailing:
                    Button(action: {
                        viewModel.sendVideoFeedback(
                            feedback: .init(
                                feedbackType: reportType,
                                message: description,
                                screenshot: nil,
                                videoURL: url
                            )
                        )
                    }, label: {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(10))
                    })
            )
            .onAppear {
                user = viewModel.loadUserName()
            }
            .alert(isPresented: $viewModel.isAlertPresented) {
                Alert(
                    title: Text(viewModel.isReportSended.title ?? ""),
                    message: nil,
                    dismissButton: .default(Text("Ok"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                )
            }
        }
    }
}

#Preview {
    VideoPreviewScreen()
}

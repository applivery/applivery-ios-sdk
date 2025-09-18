//
//  ScreenshootPreview.swift
//
//
//  Created by Fran Alarza on 10/9/24.
//

import SwiftUI


struct ScreenshootPreviewScreen: View {
    @ObservedObject var viewModel = ScreenshootViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var screenshot: UIImage?
    @State var user: String = ""
    @State var description: String = ""
    @State var reportType: FeedbackType = .feedback
    @State var imageLines: [Line] = []
    @State var imageIsSelected: Bool = true
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Divider()
                ReportTypeView(reportType: $reportType)
                Divider()
                EmailTextFieldView(user: $user, onSubmit: {})
                .disabled(!viewModel.loadUserName().isEmpty)
                Divider()

                ZStack(alignment: .topLeading) {
                    MultilineTextView(text: $description)
                        .frame(maxHeight: .infinity)
                    if description.isEmpty {
                        Text("Type Here ...")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                }

                ScreenShootRowView(
                    image: $screenshot,
                    lines: $imageLines,
                    isSelected: $imageIsSelected
                )
                .frame(height: 64)
                Spacer()
            }
            .padding()
            // iOS 13 only supports:
            .navigationBarTitle("Send \(reportType.rawValue.capitalized)")
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("X")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.blue)
                    }),
                trailing:
                    Button(action: {
                        guard let screenshot = screenshot else { return }
                        guard let newScreenShot = viewModel.exportDrawing(
                            image: screenshot,
                            lines: imageLines
                        ) else { return }
                        viewModel.sendScreenshootFeedback(
                            feedback: .init(
                                feedbackType: reportType,
                                message: description,
                                screenshot: imageIsSelected ? .init(image: newScreenShot) : nil,
                                videoURL: nil
                            )
                        )
                    }, label: {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(10))
                    })
                    .opacity(description.isEmpty ? 0.4 : 1)
                    .disabled(description.isEmpty)
                    .disabled(viewModel.isReportSended == .loading)
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
    ScreenshootPreviewScreen(screenshot: UIImage(systemName: "figure.walk") ?? UIImage())
}

#Preview("Disabled user TextField") {
    ScreenshootPreviewScreen(screenshot: UIImage(systemName: "figure.walk") ?? UIImage(), user: "paquito@gmail.com")
}

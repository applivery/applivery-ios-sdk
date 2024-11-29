//
//  ScreenshootPreview.swift
//
//
//  Created by Fran Alarza on 10/9/24.
//

import SwiftUI

struct ScreenshootPreviewScreen: View {
    @ObservedObject var viewModel = ScreenshootViewModel()
    @Environment(\.dismiss) var dismiss
    @State var screenshot: UIImage?
    @State var user: String = ""
    @State var description: String = ""
    @State var reportType: FeedbackType = .feedback
    @State var imageLines: [Line] = []
    @State var imageIsSelected: Bool = true
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
                ScreenShootRowView(
                    image: $screenshot,
                    lines: $imageLines,
                    isSelected: $imageIsSelected
                )
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
                        guard let screenshot else { return }
                        let newScreenShot = viewModel.exportDrawing(
                            image: screenshot,
                            lines: imageLines
                        )
                        
                        if let newScreenShot {
                            viewModel.sendScreenshootFeedback(
                                feedback: .init(
                                    feedbackType: reportType,
                                    message: description,
                                    screenshot: imageIsSelected ? .init(image: newScreenShot) : nil,
                                    videoURL: nil
                                )
                            )
                        }
                    }, label: {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(10))
                    })
                    .opacity(description.isEmpty ? 0.4 : 1)
                    .disabled(description.isEmpty)
                }
            })
            .alert(viewModel.isReportSended.title ?? "", isPresented: $viewModel.isAlertPresented, actions: {
                Button(action: {
                    dismiss.callAsFunction()
                }, label: {
                    Text("Ok")
                })
            })
            .onAppear {
                user = viewModel.loadUserName()
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

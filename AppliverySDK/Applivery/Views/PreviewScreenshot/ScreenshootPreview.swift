//
//  ScreenshootPreview.swift
//
//
//  Created by Fran Alarza on 10/9/24.
//

import SwiftUI

struct ScreenshootPreview: View {
    @Environment(\.dismiss) var dismiss
    let screenshot: UIImage?
    @State var description: String = ""
    @State var selectionType: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if let screenshot {
                    Image(uiImage: screenshot)
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Image(systemName: "figure.walk")
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                }
                Picker("Select Type", selection: $selectionType) {
                    Text(literal(.feedbackTypeFeedback) ?? "").tag(0)
                    Text(literal(.feedbackTypeBug) ?? "").tag(1)
                }
                .pickerStyle(.segmented)
                TextField("", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss.callAsFunction()
                    }, label: {
                        Text(literal(.alertButtonCancel) ?? "")
                            .foregroundColor(.white)
                    })
                }
                
                ToolbarItem(placement: .automatic) {
                    HStack {
                        Image(.appliveryLogo)
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .center)
                            .padding(.trailing, 20)
                        Spacer()
                    }
                    .frame(width: .infinity)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss.callAsFunction()
                    }, label: {
                        Text(literal(.feedbackButtonSend) ?? "")
                            .foregroundColor(.white)
                    })
                }
            })
        }
        .onAppear {
            let palette = GlobalConfig.shared.palette
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = palette.primaryColor
            appearance.titleTextAttributes = [.foregroundColor: palette.primaryFontColor]
            appearance.largeTitleTextAttributes = [.foregroundColor: palette.primaryFontColor]

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance

            UISegmentedControl.appearance().selectedSegmentTintColor = palette.primaryColor
            UISegmentedControl.appearance().backgroundColor = palette.secondaryColor
            let selectedTextColor = [NSAttributedString.Key.foregroundColor: palette.primaryFontColor]
            let normalTextColor = [NSAttributedString.Key.foregroundColor: palette.secondaryFontColor]
            UISegmentedControl.appearance().setTitleTextAttributes(normalTextColor, for: .normal)
            UISegmentedControl.appearance().setTitleTextAttributes(selectedTextColor, for: .selected)
        }
        .onDisappear {
            let defaultAppearance = UINavigationBarAppearance()
            defaultAppearance.configureWithOpaqueBackground()
            defaultAppearance.backgroundColor = .systemBackground
            defaultAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            defaultAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

            UINavigationBar.appearance().standardAppearance = defaultAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = defaultAppearance
            UINavigationBar.appearance().compactAppearance = defaultAppearance

            UISegmentedControl.appearance().selectedSegmentTintColor = nil
            UISegmentedControl.appearance().backgroundColor = nil
            UISegmentedControl.appearance().setTitleTextAttributes(nil, for: .normal)
            UISegmentedControl.appearance().setTitleTextAttributes(nil, for: .selected)
        }
    }
}

//#Preview {
//    ScreenshootPreview(screenshot: UIImage(systemName: "figure.walk") ?? UIImage())
//}

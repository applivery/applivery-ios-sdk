//
//  ForceUpdateScreen.swift
//  Applivery
//
//  Created by Fran Alarza on 3/12/24.
//

import SwiftUI

struct ForceUpdateScreen: View {
    private let pallete = GlobalConfig.shared.palette
    private let service: UpdateServiceProtocol = UpdateService(eventDetector: BackgroundDetector())
    @State var isLoading: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Text(service.forceUpdateMessage())
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    isLoading = true
                    service.downloadLastBuild(onResult: nil)
                }) {
                    Text(literal(.buttonForceUpdate) ?? "")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            
            if isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                ActivityIndicatorView(isAnimating: .constant(true), style: .large)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

#Preview {
    ForceUpdateScreen()
}

#Preview {
    ForceUpdateScreen(isLoading: true)
}

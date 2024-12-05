//
//  ForceUpdateScreen.swift
//  Applivery
//
//  Created by Fran Alarza on 3/12/24.
//

import SwiftUI

struct ForceUpdateScreen: View {
    private let pallete = GlobalConfig.shared.palette
    let service: UpdateServiceProtocol = UpdateService()
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 32) {
            Text(service.forceUpdateMessage())
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            Button(literal(.buttonForceUpdate) ?? "") {
                isLoading = true
                service.downloadLastBuild()
            }
            .buttonStyle(.borderedProminent)
        }
        .background(Color(uiColor: pallete.secondaryColor))
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    ForceUpdateScreen()
}

#Preview {
    ForceUpdateScreen(isLoading: true)
}

//
//  TimedButton.swift
//
//
//  Created by Fran Alarza on 16/9/24.
//

import SwiftUI

struct TimedButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "play.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
        }
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(lineWidth: 4)
        }
    }
}

#Preview {
    TimedButton(action: {})
}

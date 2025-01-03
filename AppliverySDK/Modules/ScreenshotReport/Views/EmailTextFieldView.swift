//
//  EmailTextFieldView.swift
//  
//
//  Created by Fran Alarza on 12/9/24.
//

import SwiftUI

struct EmailTextFieldView: View {
    @Binding var user: String
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Text("From:")
            TextField(
                "Introduce your email",
                text: $user,
                onEditingChanged: { _ in
                    // If needed, handle when editing begins/ends.
                },
                onCommit: {
                    onSubmit()
                }
            )
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            Spacer()
        }
    }
}

#Preview {
    EmailTextFieldView(user: .constant("JAIMITO@TEST.COM"), onSubmit: {})
}

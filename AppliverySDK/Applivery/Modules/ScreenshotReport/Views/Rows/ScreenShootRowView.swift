//
//  ScreenShootRowView.swift
//
//
//  Created by Fran Alarza on 11/9/24.
//

import SwiftUI

struct ScreenShootRowView: View {
    @Binding var image: UIImage?
    @Binding var lines: [Line]
    @Binding var isSelected: Bool
    @State var editScreenshootSheetIsPresented = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
                .padding(.leading, 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Screenshot")
                    .font(.system(size: 16, weight: .bold))
                Button(action: {
                    editScreenshootSheetIsPresented.toggle()
                }, label: {
                    Text("Edit Screenshot")
                        .font(.system(size: 12, weight: .bold))
                })
            }
            
            Spacer()
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isSelected.toggle()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.primary, lineWidth: 1)
        )
        .fullScreenCover(isPresented: $editScreenshootSheetIsPresented, content: {
            EditScreenshotView(screenshot: $image, lines: $lines)
        })
    }
}

#Preview {
    ScreenShootRowView(
        image: .constant(UIImage(systemName: "checkmark.circle.fill")),
        lines: .constant([]),
        isSelected: .constant(false)
    )
}

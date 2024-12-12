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
                if #available(iOS 15.0, *) {
                    Button(action: {
                        editScreenshootSheetIsPresented.toggle()
                    }, label: {
                        Text("Edit Screenshot")
                            .font(.system(size: 12, weight: .bold))
                    })
                } else {
                    // TODO: UIKit view
                }

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
        .sheet(isPresented: $editScreenshootSheetIsPresented) {
            if #available(iOS 15.0, *) {
                EditScreenshotView(screenshot: $image, lines: $lines)
                    .edgesIgnoringSafeArea(.all)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

#Preview {
    ScreenShootRowView(
        image: .constant(UIImage(systemName: "checkmark.circle.fill")),
        lines: .constant([]),
        isSelected: .constant(false)
    )
}

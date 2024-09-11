//
//  EditScreenshotView.swift
//
//
//  Created by Fran Alarza on 11/9/24.
//

import SwiftUI

struct EditScreenshotView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var screenshot: UIImage?
    @State private var paths: [Path] = []
    @State private var currentPath = Path()
    
    var body: some View {
        VStack {
            topBarView
            drawedImage
            Spacer()
        }
    }
    
    var topBarView: some View {
        HStack {
            Button(action: {
                dismiss.callAsFunction()
            }, label: {
                Text("X")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            })
            
            Spacer()
            
            Text("Edit Screenshoot")
                .font(.system(size: 16, weight: .bold))
            
            Spacer()
            
            Button(action: {
                dismiss.callAsFunction()
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(10))
            })
        }
        .padding()
    }
    
    var drawedImage: some View {
        ZStack {
            Image(uiImage: screenshot ?? UIImage())
                .resizable()
                .scaledToFit()
            
            Canvas { context, size in
                for path in paths {
                    context.stroke(path, with: .color(.red), lineWidth: 2)
                }
                context.stroke(currentPath, with: .color(.red), lineWidth: 2)
            }
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    currentPath.addLine(to: value.location)
                    paths.append(currentPath)
                }
                .onEnded { _ in
                    currentPath = Path()
                }
            )
        }
    }
}

#Preview {
    EditScreenshotView(screenshot: .constant(UIImage(systemName: "checkmark.circle.fill") ?? UIImage()))
}

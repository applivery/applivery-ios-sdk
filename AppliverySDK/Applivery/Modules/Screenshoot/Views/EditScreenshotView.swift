//
//  EditScreenshotView.swift
//
//
//  Created by Fran Alarza on 11/9/24.
//

import SwiftUI

struct Line {
    var path: Path = Path()
    var color: Color = .red
    var lineWith: Double = 1.0
}

struct EditScreenshotView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var screenshot: UIImage?
    @Binding var lines: [Line]
    @State private var currentLine: Line = Line()
    @State private var selectedColor: Color = .red
    @State private var editMode = false
    
    var body: some View {
        VStack {
            Spacer()
            drawedImage
            VStack(spacing: 0) {
                if editMode {
                    ColorPicker("Color", selection: $selectedColor)
                } else {
                    ColorPicker("Color", selection: $selectedColor)
                        .hidden()
                }
                topBarView
            }
        }
        .onChange(of: selectedColor, perform: { value in
            currentLine.color = value
        })
        .animation(.easeIn, value: editMode)
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
            
            Button(action: {
                editMode.toggle()
            }, label: {
                Image(systemName: "pencil.and.scribble")
                    .foregroundColor(editMode ? .blue : .black)
            })
            
            Spacer()
            
            Button(action: {
                lines.remove(at: lines.count - 1)
            }, label: {
                Image(systemName: "arrow.uturn.backward")
            })
            .foregroundColor(lines.isEmpty ? .gray : .black)
            .disabled(lines.isEmpty)
            
            Spacer()
            
            Button(action: {
                saveDrawing()
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
                for line in lines {
                    context.stroke(line.path, with: .color(line.color), lineWidth: line.lineWith)
                }
                context.stroke(currentLine.path, with: .color(selectedColor), lineWidth: currentLine.lineWith)
            }
            .gesture(dragGesture)
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                if editMode {
                    currentLine.path.addLine(to: value.location)
                }
            }
            .onEnded { _ in
                lines.append(currentLine)
                currentLine = Line()
            }
    }
    
    func saveDrawing() {
        guard let baseImage = screenshot else { return }

        // Crear un renderizador con el tamaño de la imagen
        let renderer = UIGraphicsImageRenderer(size: baseImage.size)
        
        let transformedImage = renderer.image { context in
            baseImage.draw(at: .zero)
            
            // Dibujar las líneas en la imagen
            let scaleX = baseImage.size.width / UIScreen.main.bounds.width
            let scaleY = baseImage.size.height / UIScreen.main.bounds.height
            
//            let firstLineStart = CGPoint(x: baseImage.size.width * 0.1, y: baseImage.size.height * 0.1)
//            let firstLineEnd = CGPoint(x: baseImage.size.width * 0.9, y: baseImage.size.height * 0.1)
//            context.cgContext.move(to: firstLineStart)
//            context.cgContext.addLine(to: firstLineEnd)
//            context.cgContext.strokePath()
            
            for line in lines {
                let path = line.path
                let transformedPath = path.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
                context.cgContext.move(to: line.path.boundingRect.origin)
                context.cgContext.addLine(to: line.path.currentPoint ?? CGPoint())
                context.cgContext.setStrokeColor(UIColor(line.color).cgColor)
                context.cgContext.setLineWidth(line.lineWith)
                context.cgContext.strokePath()
            }
        }
        
        self.screenshot = transformedImage
    }
}

#Preview {
    EditScreenshotView(screenshot: .constant(UIImage(systemName: "checkmark.circle.fill") ?? UIImage()), lines: .constant([]))
}

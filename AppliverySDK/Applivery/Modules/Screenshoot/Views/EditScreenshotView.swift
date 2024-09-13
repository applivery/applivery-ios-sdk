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
    var lineWith: Double = 2.0
}

struct EditScreenshotView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var screenshot: UIImage?
    @Binding var lines: [Line]
    @State private var currentLine: Line = Line()
    @State private var selectedColor: Color = .red
    @State private var selectedStroke: Double = 2.0
    @State private var editMode = false
    
    var body: some View {
        VStack {
            Spacer()
            drawedImage
            VStack(spacing: 12) {
                
                bottomBarView
            }
            .padding()
        }
        .overlay(alignment: .bottom, content: {
            if editMode {
                editTools
                    .padding(.bottom, 72)
            }
        })
        .animation(.easeIn, value: editMode)
    }
    
    var bottomBarView: some View {
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
                dismiss.callAsFunction()
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(lines.isEmpty ? .gray : .blue)
                    .rotationEffect(.degrees(10))
            })
            .disabled(lines.isEmpty)
        }
    }
    
    var drawedImage: some View {
        ZStack {
            Image(uiImage: screenshot ?? UIImage())
                .resizable()
            
            Canvas { context, size in
                for line in lines {
                    context.stroke(line.path, with: .color(line.color), lineWidth: line.lineWith)
                }

                context.stroke(currentLine.path, with: .color(currentLine.color), lineWidth: currentLine.lineWith)
            }
            .gesture(dragGesture)
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if editMode {
                    currentLine.path.addLine(to: value.location)
                }
            }
            .onEnded { _ in
                lines.append(currentLine)
                currentLine = Line(path: Path(), color: selectedColor, lineWith: selectedStroke)
            }
    }
    
    var editTools: some View {
        HStack {
            Slider(value: $selectedStroke, in: 2...10, step: 0.1)
                .onChange(of: selectedStroke, perform: { newWith in
                    currentLine = Line(color: currentLine.color, lineWith: newWith)
                })
            ColorPicker("", selection: $selectedColor)
                .onChange(of: selectedColor, perform: { newColor in
                    currentLine = Line(color: newColor, lineWith: currentLine.lineWith)
                })
        }
        .background(.white)
        .padding(.horizontal, 100)
    }
}

#Preview {
    EditScreenshotView(screenshot: .constant(UIImage(systemName: "checkmark.circle.fill") ?? UIImage()), lines: .constant([]))
}

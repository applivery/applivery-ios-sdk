//
//  EditScreenshotView.swift
//
//
//  Created by Fran Alarza on 11/9/24.
//

import SwiftUI

struct Line {
    var path: Path
    var points: [CGPoint] = []
    var color: Color = .red
    var lineWidth: Double = 2.0
    
    init(
        path: Path = Path(),
        points: [CGPoint] = [],
        color: Color = .red,
        lineWidth: Double = 2.0
    ) {
        self.path = path
        self.points = points
        self.color = color
        self.lineWidth = lineWidth
    }
}

@available(iOS 15.0, *)
struct EditScreenshotView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var screenshot: UIImage?
    @Binding var lines: [Line]
    @State private var currentLine: Line = Line()
    @State private var selectedColor: Color = .red
    @State private var selectedStroke: Double = 2.0
    @State private var editMode = false
    
    @State private var pixelSize = PixelSize()
    @State private var viewSize = CGSize.zero
    
    var body: some View {
        VStack {
            Spacer()
            drawedImage
            Spacer()
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
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)
            })
            
            Spacer()
            
            Button(action: {
                editMode.toggle()
            }, label: {
                Image(systemName: "pencil.and.scribble")
                    .foregroundColor(editMode ? .blue : .primary)
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
    
    @ViewBuilder
    var drawedImage: some View {
        if let screenshot {
            ZStack {
                Image(uiImage: screenshot)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .saveSize(in: $viewSize) // NOTE: this is the screen size for the image!
                    .overlay {
                        Canvas {
                            context,
                            size in
                            for line in lines {
                                context.stroke(
                                    line.path,
                                    with: .color(line.color),
                                    lineWidth: line.lineWidth
                                )
                            }
                            
                            context.stroke(
                                currentLine.path,
                                with: .color(currentLine.color),
                                lineWidth: currentLine.lineWidth
                            )
                        }
                        .gesture(dragGesture)
                    }
                    .onAppear {
                        pixelSize = screenshot.pixelSize
                    }
            }
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                currentLine.path.addLine(to: value.location)
                currentLine.points.append(limitPoint(value.location))
            }
            .onEnded { _ in
                lines.append(currentLine)
                currentLine = Line(
                    path: Path(),
                    color: selectedColor,
                    lineWidth: selectedStroke
                )
            }
    }
    
    var editTools: some View {
        HStack {
            Slider(value: $selectedStroke, in: 2...10, step: 0.1)
                .onChange(of: selectedStroke, perform: { newWith in
                    currentLine = Line(color: currentLine.color, lineWidth: newWith)
                })
            ColorPicker("", selection: $selectedColor)
                .onChange(of: selectedColor, perform: { newColor in
                    currentLine = Line(color: newColor, lineWidth: currentLine.lineWidth)
                })
        }
        .padding(8)
        .background()
        .padding(.horizontal, 50)
        
    }
    
//    func screenPoint(_ point: CGPoint) -> CGPoint {
//        // Convert 0->1 to view's coordinates
//        debugPrint("ViewSize \(viewSize)")
//        let vw = viewSize.width
//        let vh = viewSize.height
//        let nextX = min(1, max(0, point.x)) * vw
//        let nextY = min(1, max(0, point.y)) * vh
//        return CGPoint(x: nextX, y: nextY)
//    }

    func limitPoint(_ point: CGPoint) -> CGPoint {
        debugPrint("ViewSize \(viewSize)")
        // Convert view coordinate to normalized 0->1 range
        let vw = max(viewSize.width, 1)
        let vh = max(viewSize.height, 1)

        // Keep in bounds - even if dragging outside of bounds
        let nextX = min(1, max(0, point.x / vw))
        let nextY = min(1, max(0, point.y / vh))
        return CGPoint(x: nextX, y: nextY)
    }
}

#Preview {
    if #available(iOS 15.0, *) {
        EditScreenshotView(screenshot: .constant(UIImage(systemName: "checkmark.circle.fill") ?? UIImage()), lines: .constant([]))
    } else {
        // Fallback on earlier versions
    }
}

// Auxiliary definitions and functions

struct PixelSize {
    var width: Int = 0
    var height: Int = 0
}

extension UIImage {
    var pixelSize: PixelSize {
        if let cgImage = cgImage {
            return PixelSize(width: cgImage.width, height: cgImage.height)
        }
        return PixelSize()
    }
}

// SizeCalculator from: https://stackoverflow.com/questions/57577462/get-width-of-a-view-using-in-swiftui

@available(iOS 15.0, *)
struct SizeCalculator: ViewModifier {

    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size = proxy.size
                        }
                        .onChange(of: proxy.size) { size in // Added to handle device rotation
                            self.size = size
                        }
                }
            )
    }
}

@available(iOS 15.0, *)
extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}

//
//  ColorPickerView.swift
//
//
//  Created by Fran Alarza on 12/9/24.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    let colors: [Color] = [.blue, .red, .black, .pink, .yellow, .green]
    var body: some View {
        HStack {
            ForEach(colors, id: \.description) { color in
                buildColorSelector(color: color)
            }
        }
    }
    
    func buildColorSelector(color: Color) -> some View {
        Image(systemName: selectedColor == color ? "smallcircle.filled.circle.fill" : "circle.fill")
            .foregroundColor(color)
            .font(.system(size: 16))
            .clipShape(Circle())
            .frame(maxWidth: .infinity)
            .onTapGesture {
                selectedColor = color
            }
    }
    
}

#Preview {
    return ColorPickerView(selectedColor: .constant(.blue))
}

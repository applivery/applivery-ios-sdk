//
//  OptionsListView.swift
//  Applivery
//
//  Created by Fran Alarza on 8/4/25.
//

import SwiftUI

struct OptionsListView: View {
    let title: String
    let options: [TimeInterval]
    let selectionHandler: (TimeInterval) -> Void
    
    private let pallete = GlobalConfig.shared.palette
    
    @State var selectedOption: TimeInterval?

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 24, weight: .medium))
                VStack(spacing: 0) {
                    ForEach(options.prefix(3), id: \.self) { option in
                        buildRowView(interval: option)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack {
                    cancelButton
                    selectButton
                }
                
            }
            .padding()
            .frame(maxWidth: 300, maxHeight: 250)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .onAppear {
                if !options.isEmpty {
                    selectedOption = options.first
                }
            }

        }
    }
    
    var selectButton: some View {
        Button(action: {
            if let selectedOption = selectedOption {
                selectionHandler(selectedOption)
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Select")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(pallete.primaryColor))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    
    var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    
    func buildRowView(interval: TimeInterval) -> some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 16, height: 16)
                if selectedOption == interval {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color(pallete.primaryColor))
                }
                
            }
            
            Text(interval.formatTimeInterval)
                .padding(.leading, 8)
                .font(.system(size: 16, weight: .medium))
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedOption = interval
        }
        .padding(8)
    }
}

#Preview {
    OptionsListView(title: "Postpone alert for:", options: [30, 300, 60*60*24], selectionHandler: { _ in })
}

//
//  VideoPreviewRow.swift
//
//
//  Created by Fran Alarza on 12/9/24.
//

import SwiftUI
import AVFoundation

struct VideoPreviewRow: View {
    @Binding var videoURL: URL?
    @State private var thumbnailImage: UIImage? = nil
    @State var isSelected: Bool = true
    @State var editScreenshootSheetIsPresented = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
                .padding(.leading, 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Video Clip")
                    .font(.system(size: 16, weight: .bold))
                Button(action: {
                    editScreenshootSheetIsPresented.toggle()
                }, label: {
                    Text("Watch Preview")
                        .font(.system(size: 12, weight: .bold))
                })
            }
            
            Spacer()
            
            if let thumbnailImage {
                Image(uiImage: thumbnailImage)
                    .resizable()
                    .scaledToFit()
            }
        }
        .contentShape(Rectangle())
        .onAppear {
            if let videoURL {
                generateThumbnail(url: videoURL) { image in
                    if let image = image {
                        self.thumbnailImage = image
                    }
                }
            }
            
        }
        .onTapGesture {
            isSelected.toggle()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.black, lineWidth: 1)
        )
        .sheet(isPresented: $editScreenshootSheetIsPresented, content: {
            if let videoURL {
                ViedeoPlayerView(videoURL: videoURL)
            }
        })
    }
    
    func generateThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        let time = CMTime(seconds: 1, preferredTimescale: 60)
        DispatchQueue.global().async {
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let uiImage = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(uiImage)
                }
            } catch {
                print("Error al generar la miniatura: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

#Preview {
    VideoPreviewRow(videoURL: .constant(URL(string: "https://www.google.es")))
}

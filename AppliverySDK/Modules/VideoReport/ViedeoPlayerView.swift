//
//  ViedeoPlayerView.swift
//
//
//  Created by Fran Alarza on 13/9/24.
//

import SwiftUI
import AVKit
import AVFoundation

struct ViedeoPlayerView: View {
    let videoURL: URL
    
    var body: some View {
        VideoPlayerViewRepresentable(videoURL: videoURL)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ViedeoPlayerView(videoURL: URL(string: "https://www.example.com/video.mp4")!)
}

struct VideoPlayerViewRepresentable: UIViewControllerRepresentable {
    
    var videoURL: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        player.play()
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No se necesita actualizar nada
    }
}

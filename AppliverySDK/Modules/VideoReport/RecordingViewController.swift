//
//  RecordingViewController.swift
//  
//
//  Created by Fran Alarza on 4/9/24.
//

import UIKit

class RecordingViewController: UIViewController {
    
    private var recordButton: UIButton = UIButton(type: .system)
    private let borderLayer = CAShapeLayer()
    private var actionSheet: UIAlertController = UIAlertController()
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        if #available(iOS 15.0, *) {
            addRecordButton()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        recordButton.layer.cornerRadius = recordButton.bounds.size.width / 2
        
        borderLayer.frame = recordButton.bounds
        borderLayer.path = UIBezierPath(ovalIn: borderLayer.bounds).cgPath
    }
    
    deinit {
        print("RecordingViewController - deint")
    }
    
    @objc func recordButtonTapped() {
        buttonAction?()
    }

    private func addRecordButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 48, weight: .heavy)
        let symbolImage = UIImage(systemName: "stop.circle.fill", withConfiguration: configuration)
        recordButton.setImage(symbolImage, for: .normal)
        recordButton.tintColor = .lightGray
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.clipsToBounds = true
        recordButton.isHidden = true

        view.addSubview(self.recordButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            recordButton.widthAnchor.constraint(equalToConstant: 48),
            recordButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        borderLayer.strokeColor = UIColor.red.cgColor
        borderLayer.lineWidth = 8
        borderLayer.fillColor = nil

        recordButton.layer.addSublayer(borderLayer)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        recordButton.addGestureRecognizer(panGesture)
    }
    
    private func animateBorder() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 30
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        borderLayer.add(animation, forKey: "borderAnimation")
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view else { return }
        
        let translation = gesture.translation(in: view)
        
        button.center = CGPoint(x: button.center.x + translation.x, y: button.center.y + translation.y)
        
        gesture.setTranslation(.zero, in: view)
    }
    
    func showRecordButton() {
        self.recordButton.isHidden = false
        animateBorder()
    }

    func hideRecordButton() {
        self.recordButton.isHidden = true
    }
    
    public func shouldReceiveTouch(windowPoint point: CGPoint) -> Bool {
        var shouldReceiveTouch = false
        
        let pointInLocalCoordinates = view.convert(point, from: nil)
        
        if (CGRectContainsPoint(recordButton.frame, pointInLocalCoordinates)) {
            shouldReceiveTouch = true
        } else if (CGRectContainsPoint(actionSheet.view.frame, pointInLocalCoordinates)) {
            shouldReceiveTouch = true
        }
        
        return shouldReceiveTouch
    }
    
    func presentActionSheet() {
        actionSheet = UIAlertController()
        
        let screenshotAction = UIAlertAction(title: literal(.sheetScreenshotAction), style: .default) { _ in
            ScreenRecorderManager.shared.presentPreviewWithScreenshoot()
        }
        
        let screenRecordingAction = UIAlertAction(title: literal(.sheetRecordAction), style: .default) { _ in
            ScreenRecorderManager.shared.startClipBuffering()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if #available(iOS 15.0, *) {
            actionSheet.addAction(screenshotAction)
            actionSheet.addAction(screenRecordingAction)
            actionSheet.addAction(cancelAction)
        } else {
            actionSheet.addAction(screenshotAction)
            actionSheet.addAction(cancelAction)
        }
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        generateImpactFeedback(style: .heavy)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func generateImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

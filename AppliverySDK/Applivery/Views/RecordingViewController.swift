//
//  RecordingViewController.swift
//  
//
//  Created by Fran Alarza on 4/9/24.
//

import UIKit

class RecordingViewController: UIViewController {
    
    private var recordButton: UIButton = UIButton(type: .system)
    private var actionSheet: UIAlertController = UIAlertController()
    var buttonAction: (() -> Void)?
    
    private var feedbackCoordinator: PFeedbackCoordinator
    private let shapeLayer = CAShapeLayer()
    
    init(feedbackCoordinator: PFeedbackCoordinator) {
        self.feedbackCoordinator = feedbackCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addRecordButton()
        setupProgressBorder()
    }
    
    deinit {
        print("RecordingViewController - deint")
    }
    
    @objc func recordButtonTapped() {
        buttonAction?()
    }

    private func addRecordButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 32, weight: .heavy)
        let symbolImage = UIImage(systemName: "stop.circle.fill", withConfiguration: configuration)
        recordButton.setImage(symbolImage, for: .normal)
        recordButton.tintColor = .white
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.isHidden = true

        view.addSubview(self.recordButton)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        recordButton.addGestureRecognizer(panGesture)
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view else { return }
        
        let translation = gesture.translation(in: view)
        
        button.center = CGPoint(x: button.center.x + translation.x, y: button.center.y + translation.y)
        
        gesture.setTranslation(.zero, in: view)
    }
    
    private func setupProgressBorder() {
        let circularPath = UIBezierPath(
            arcCenter: .init(
                x: recordButton.frame.midX,
                y: recordButton.frame.midY
            ),
            radius: recordButton.bounds.width + 10,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        
        //view.layer.addSublayer(shapeLayer)
        
    }
    
    private func startProgressAnimation() {
        shapeLayer.strokeEnd = 0

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 30
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "progressAnimation")
    }
    
    func showRecordButton() {
        self.recordButton.isHidden = false
        startProgressAnimation()
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
        actionSheet = UIAlertController(title: "Applivery SDK", message: "Powered by Applivery", preferredStyle: .actionSheet)
        
        let screenshotAction = UIAlertAction(title: "Tomar Captura de Pantalla", style: .default) { _ in
            ScreenRecorderManager.shared.presentPreviewWithScreenshoot()
        }
        
        let screenRecordingAction = UIAlertAction(title: "Iniciar Grabación de Pantalla", style: .default) { _ in
            ScreenRecorderManager.shared.startClipBuffering()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        actionSheet.addAction(screenshotAction)
        actionSheet.addAction(screenRecordingAction)
        actionSheet.addAction(cancelAction)
        
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

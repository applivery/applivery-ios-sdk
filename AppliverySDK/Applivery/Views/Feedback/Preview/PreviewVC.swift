//
//  PreviewVC.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 27/11/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController, UIGestureRecognizerDelegate {
	
	var screenshot: UIImage? {
		didSet {
			self.imageScreenshot?.image = self.screenshot
		}
	}
	
	var editedScreenshot: UIImage? {
		return self.imageScreenshot?.image
	}
	
	// PRIVATE
	private var brushWidth: CGFloat = 3
	private var brushColor: UIColor = GlobalConfig.shared.palette.screenshotBrushColor
	private var lastPoint = CGPoint.zero
	
	// UI Properties
	@IBOutlet private weak var imageScreenshot: UIImageView?
	
	
	// MARK: - View's life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	// MARK: - Gesture Delegate
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return logWarn("No touches found")
		}
		
		self.lastPoint = touch.location(in: self.imageScreenshot)
	}
 
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first  else {
			return logWarn("No touches found")
		}
		
		let currentPoint = touch.location(in: view)
		self.drawLineFrom(fromPoint: self.lastPoint, toPoint: currentPoint)
		self.lastPoint = currentPoint
	}
	
	func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
		guard let size = self.imageScreenshot?.frame.size else {
			return logWarn("Could not retrieved size")
		}
		
		// Behan to draw
		UIGraphicsBeginImageContext(size)
		let context = UIGraphicsGetCurrentContext()
		self.imageScreenshot?.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
		
		// Draw the line in the context
		context?.move(to: fromPoint)
		context?.addLine(to: toPoint)
		context?.setLineCap(.round)
		context?.setLineWidth(self.brushWidth)
		context?.setStrokeColor(self.brushColor.cgColor)
		context?.setBlendMode(.normal)
		context?.strokePath()
		
		// En the draw
		self.imageScreenshot?.image = UIGraphicsGetImageFromCurrentImageContext()
		self.imageScreenshot?.alpha = 1.0
		UIGraphicsEndImageContext()
	}
	
}

//
//  UIImageExtension.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 13/01/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	
	func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
		//Calculate the size of the rotated view's containing box for our drawing space
		let rotatedViewBox = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
		let transform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
		rotatedViewBox.transform = transform
		let rotatedSize = rotatedViewBox.frame.size
		//Create the bitmap context
		UIGraphicsBeginImageContextWithOptions(rotatedSize, false, UIScreen.main.scale)
		guard let bitmap = UIGraphicsGetCurrentContext() else { return self }
		//Move the origin to the middle of the image so we will rotate and scale around the center.
		bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
		//Rotate the image context
		bitmap.rotate(by: (degrees * CGFloat.pi / 180))
		//Now, draw the rotated/scaled image into the context
		bitmap.scaleBy(x: 1.0, y: -1.0)
		guard let cgImage = self.cgImage else { return self }
		bitmap.draw(cgImage, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
		guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
		UIGraphicsEndImageContext()
		return newImage
	}
	
}

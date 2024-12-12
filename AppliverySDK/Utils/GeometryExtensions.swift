//
//  GeometryExtensions.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 12/01/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
	func screenScaled() -> CGPoint {
		let scale = UIScreen.main.scale
		return CGPoint(x: self.x * scale, y: self.y * scale)
	}
}

extension CGSize {
	func screenScaled() -> CGSize {
		let scale = UIScreen.main.scale
		return CGSize(width: self.width.rounded() * scale, height: self.height.rounded() * scale)
	}
}

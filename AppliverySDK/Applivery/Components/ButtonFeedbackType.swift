//
//  ButtonFeedbackType.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 13/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class ButtonFeedbackType: UIButton {

	var feedbackType: FeedbackType!

	var exclusive: ButtonFeedbackType? {
		didSet {
			self.exclusive?.exclusive = self
		}
	}

	override var isSelected: Bool {
		willSet(newValue) {
			self.toState(newValue)
		}
	}


	// MARK - Initializers

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
	}


	// MARK - Private Helpers

	fileprivate func setupView() {
		self.setTitleColor(UIColor.white, for: .selected)
		self.setTitleColor(UIColor.LabelBlack(), for: UIControlState())

	}

	fileprivate func toState(_ selected: Bool) {
		if selected {
			self.backgroundColor = UIColor.AppliveryBig()

			if let exclusive = self.exclusive {
				exclusive.isSelected = false
			}
		} else {
			self.backgroundColor = UIColor.clear
		}
	}

}

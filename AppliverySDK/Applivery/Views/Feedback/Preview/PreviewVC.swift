//
//  PreviewVC.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 27/11/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController {

	var screenshot: UIImage? {
		didSet {
			self.imageScreenshot?.image = self.screenshot
		}
	}
	
	@IBOutlet private weak var imageScreenshot: UIImageView?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

//
//  TextLiterals.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 26/3/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Foundation

public class TextLiterals: NSObject {
	
	public var appName: String = localize("sdk_name")
	
	// MARK: - OTA Update
	public var otaUpdateMessage: String?
	public var alertButtonLater: String = localize("alert_button_later")
	public var alertButtonUpdate: String = localize("alert_button_update")
	
}

enum Literal: CustomStringConvertible {
	case appName
	case otaUpdateMessage
	case alertButtonLater
	case alertButtonUpdate
	
	
	var description: String {
		return literal(self) ?? String(self.hashValue)
	}
}

func literal(_ literal: Literal) -> String? {
	let literals = GlobalConfig.shared.textLiterals
	
	switch literal {
	case .appName: return literals.appName
	case .otaUpdateMessage: return literals.otaUpdateMessage
	case .alertButtonLater: return literals.alertButtonLater
	case .alertButtonUpdate: return literals.alertButtonUpdate
	}
}

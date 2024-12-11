//
//  NSBundle+Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 18/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

extension Bundle {
    
    class func applivery() -> Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: Applivery.self)
            .url(forResource: "Applivery", withExtension: "bundle")
            .flatMap(Bundle.init(url:))
            ?? Bundle(for: Applivery.self)
        #endif
    }
    
}

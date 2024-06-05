//
//  spectre.swift
//  passe
//
//  Created by George Watson on 05/06/2024.
//

import Foundation

func GeneratePassword(name: String, password: String, site: String, siteCounter: Int = 1, keyScope: String = "test", type: SpectreTemplate = SpectreLong) -> String? {
    let _name = (name as NSString).utf8String
    let _password = (password as NSString).utf8String
    let _site = (site as NSString).utf8String
    let _siteCounter = Int32(siteCounter)
    let _keyScope = (keyScope as NSString).utf8String
    let result = SpectreGenerate(_name, _password, _site, _siteCounter, _keyScope, type)
    if let cResult = result {
        let generatedString = String(cString: cResult)
        // No need for free as memory is managed by ARC
        return generatedString
    } else {
        return nil
    }
}

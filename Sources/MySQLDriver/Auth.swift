//
//  Auth.swift
//  MySQLDriver
//
//  Created by iCell on 2019/1/4.
//

import Foundation
import CryptoSwift

func auth(authData: Bytes, password: String, plugin: String) -> Bytes {
    switch plugin {
    case defaultAuthPlugin:
        return scramblePassword(scramble: authData, password: password)
    default:
        // TODO: more plugins support
        return []
    }
}

func scramblePassword(scramble: Bytes, password: String) -> Bytes {
    guard !password.isEmpty else {
        return []
    }

    let firstStep = Data(password.utf8).sha1()
    let secondStep = firstStep.sha1()
    
    var scr = scramble
    scr.append(contentsOf: secondStep)
    
    var thirdStep = scr.sha1()
    
    for i in 0..<thirdStep.count {
        thirdStep[i] ^= firstStep[i]
    }
    
    return thirdStep
}

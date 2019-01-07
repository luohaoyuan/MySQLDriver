//
//  Auth.swift
//  MySQLDriver
//
//  Created by iCell on 2019/1/4.
//

import Foundation
import CryptoSwift

final class Auth {
    static func auth(scramble: Bytes, password: String?, plugin: String) -> Bytes {
        guard let password = password else {
            return []
        }
        switch plugin {
        case defaultAuthPlugin:
            return scramblePassword(scramble: scramble, password: password)
        default:
            // TODO: more plugins support
            return []
        }
    }
    
    static func scramblePassword(scramble: Bytes, password: String) -> Bytes {
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
}

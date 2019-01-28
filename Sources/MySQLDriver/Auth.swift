//
//  Auth.swift
//  MySQLDriver
//
//  Created by iCell on 2019/1/4.
//

import Foundation
import CryptoSwift

enum AuthPlugin: String {
    case old = "mysql_old_password"
    case sha256 = "sha256_password"
    case native = "mysql_native_password"
    case cachingSHA2 = "caching_sha2_password"
}

final class Auth {
    static func auth(scramble: Bytes, password: String?, plugin: AuthPlugin) -> Bytes {
        guard let password = password else {
            return []
        }
        switch plugin {
        case .native:
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

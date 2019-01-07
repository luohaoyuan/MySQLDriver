//
//  Utils.swift
//  MySQLDriver
//
//  Created by iCell on 2019/1/7.
//

import Foundation

func appendLengthEncodedInteger(n: UInt64) -> Bytes {
    var bytes = Bytes()
    
    switch n {
    case n where n <= 250:
        bytes.append(Byte(n))
    case n where n <= 0xffff:
        bytes.append(contentsOf: [0xfc, Byte(n), Byte(n >> 8)])
    case n where n <= 0xffffff:
        bytes.append(contentsOf: [0xfd, Byte(n), Byte(n >> 8), Byte(n >> 16)])
    default:
        bytes.append(contentsOf: [0xfe, Byte(n), Byte(n >> 8), Byte(n >> 16), Byte(n >> 24), Byte(n >> 32), Byte(n >> 40), Byte(n >> 48), Byte(n >> 56)])
    }
    
    return bytes
}

func readLengthEncodedInteger(bytes: Bytes) -> (UInt64?, Int) {
    if bytes.count == 0 {
        return (nil, 1)
    }
    
    switch bytes[0] {
    // 251: NULL
    case 0xfb:
        return (nil, 1)
        
    // 252: value of following 2
    case 0xfc:
        return (UInt64(bytes[1]) | UInt64(bytes[2]) << 8, 3)
        
    // 253: value of following 3
    case 0xfd:
        return (UInt64(bytes[1]) | UInt64(bytes[2]) << 8 | UInt64(bytes[3]) << 16, 4)
        
    // 254: value of following 8
    case 0xfe:
        let u1 = UInt64(bytes[1])
        let u2 = UInt64(bytes[2]) << 8
        let u3 = UInt64(bytes[3]) << 16
        let u4 = UInt64(bytes[4]) << 24
        let u5 = UInt64(bytes[5]) << 32
        let u6 = UInt64(bytes[6]) << 40
        let u7 = UInt64(bytes[7]) << 48
        let u8 = UInt64(bytes[8]) << 56
        return (u1 | u2 | u3 | u4 | u5 | u6 | u7 | u8, 9)
    
    default:
        break
    }
    
    // 0-250: value of first byte
    return (UInt64(bytes[0]), 1)
}

//
//  OKPacket.swift
//  MySQLDriver
//
//  Created by Li Xiaoyu on 2019/1/7.
//

import Foundation

struct OKPacket {
    let affectedRows: UInt64
    let insertID: UInt64
    let status: UInt16
    
    init(bytes: Bytes) {
        let (affectedRows, n) = readLengthEncodedInteger(bytes: bytes)
        
        let (insertID, m) = readLengthEncodedInteger(bytes: Bytes(bytes[n..<bytes.count]))
        
        self.affectedRows = affectedRows ?? 0
        self.insertID = insertID ?? 0
        self.status = UInt16(bytes[n + m]) | UInt16(bytes[n + m + 1]) << 8
    }
}

//
//  Handshake.swift
//  MySQLDriver
//
//  Created by iCell on 2019/1/4.
//

import Foundation

struct Handshake {
    /// int<1>, Always 10
    let protocolVersion: UInt8
    
    /// string<NUL>
    let serverVersion: String
    
    /// int<4>, a.k.a connection id
    let threadID: UInt32
    
    /// string[8], first 8 bytes of the plugin provided data
    let scramble: Bytes
    
    /// int<1>, 0x00, terminating the first part of scramble
//    let filler: Int
    
    /// int<2>, the lower 2 bytes of the Capabilities Flags
    /// https://dev.mysql.com/doc/dev/mysql-server/latest/group__group__cs__capabilities__flags.html
    let capabilityFlagsLow: UInt16
    
    /// int<1>, default server a_protocol_character_set, only the lower 8-bits
    let characterSet: Int
    
    /// int<2>
    let statusFlags: Int
    
    let capabilityFlagsHigh: UInt16
    
    let scramble2: Bytes
    
    let plugin: String
    
    init(payload: Bytes) throws {
        let buffer = Buffer(bytes: payload)
    
        let protoV = buffer.readNextByte()
        guard protoV >= minProtocolVersion else {
            throw Err.ErrInvalidProtoVersion
        }
        self.protocolVersion = protoV
        
        self.serverVersion = String(cString: UnsafePointer<Byte>(buffer.readNextNullTerminatedString()))
        
        let threadIDBuf = buffer.readNext(need: 4)
        self.threadID = threadIDBuf.uInt32()
        
        self.scramble = buffer.readNext(need: 8)
        
        // skip the filler
        _ = buffer.readNextByte()
        
        let capFlagsLowBuf = buffer.readNext(need: 2)
        self.capabilityFlagsLow = capFlagsLowBuf.uInt16()
        
        self.characterSet = Int(buffer.readNextByte())
        
        let serverStatusBuf = buffer.readNext(need: 2)
        self.statusFlags = Int(UInt32(serverStatusBuf[0]) | UInt32(serverStatusBuf[1]))
        
        let capFlagsHighBuf = buffer.readNext(need: 2)
        self.capabilityFlagsHigh = capFlagsHighBuf.uInt16()
        
        _ = buffer.readNextByte()
        _ = buffer.readNext(need: 10)
        
        self.scramble2 = buffer.readNextNullTerminatedString()
        
        self.plugin = String(cString: UnsafePointer<Byte>(buffer.readNextNullTerminatedString()))
    }
}

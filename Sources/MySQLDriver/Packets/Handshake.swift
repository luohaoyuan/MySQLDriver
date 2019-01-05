//
//  Handshake.swift
//  MySQLDriver
//
//  Created by iCell on 2019/1/4.
//

import Foundation

/// Protocol::HandshakeV10
/// https://dev.mysql.com/doc/dev/mysql-server/latest/page_protocol_connection_phase_packets_protocol_handshake_v10.html
struct Handshake {
    /// int<1>, Always 10
    let protoVersion: UInt8
    
    /// string<NUL>
    let serverVersion: String
    
    /// int<4>, a.k.a connection id
    let connID: UInt32
    
    /// string[8], first 8 bytes of the plugin provided data
    let scramble: Bytes
    
    /// int<2>, the lower 2 bytes of the Capabilities Flags
    /// https://dev.mysql.com/doc/dev/mysql-server/latest/group__group__cs__capabilities__flags.html
    let flags: UInt16
    
    /// int<1>, default server a_protocol_character_set, only the lower 8-bits
    let characterSet: Int
    
    /// int<2>
    let status: Int
    
    /// Rest of the plugin provided data (scramble), $len=MAX(13, length of auth-plugin-data - 8)
    let flagsHigh: UInt16
    
    /// name of the auth_method that the auth_plugin_data belongs to
    let plugin: String
    
    init(payload: Bytes) throws {
        let buffer = Buffer(bytes: payload)
        
        let protoVersion = buffer.readNextByte()
        guard protoVersion >= minProtocolVersion else {
            throw Err.ErrInvalidProtoVersion
        }
        self.protoVersion = protoVersion
        
        self.serverVersion = buffer.readNextNullTerminatedBytes().string()
        
        let connIDBuf = buffer.readNext(need: 4)
        self.connID = connIDBuf.uInt32()
        
        var scramble = buffer.readNext(need: 8)
        
        // skip the filler
        _ = buffer.readNextByte()
        
        self.flags = buffer.readNext(need: 2).uInt16()
        if UInt32(flags) & ClientFlag.protocol41.rawValue == 0 {
            throw Err.ErrOldProtocol
        }
        
        self.characterSet = Int(buffer.readNextByte())

        let statusBuf = buffer.readNext(need: 2)
        self.status = Int(UInt32(statusBuf[0]) | UInt32(statusBuf[1]))
        
        self.flagsHigh = buffer.readNext(need: 2).uInt16()
        
        _ = buffer.readNextByte()
        _ = buffer.readNext(need: 10)
        
        let scramble2 = buffer.readNextNullTerminatedBytes()
        scramble.append(contentsOf: scramble2)
        self.scramble = scramble2

        self.plugin = buffer.readNextNullTerminatedBytes().string()
    }
}

extension Handshake {
    public func responsePacket(config: Config) -> Bytes {
        return []
    }
}

//
//  Packet.swift
//  MySQLDriver
//
//  Created by iCell on 2019/1/4.
//

import Foundation
import Socket

/// Data between client and server is exchanged in packets of max 16MByte size.
struct Packet {

    /// int<3>, Length of the payload. The number of bytes in the packet beyond the initial 4 bytes that make up the packet header.
    let payloadLength: Int
    
    /// The sequence-id is incremented with each packet and may wrap around. It starts at 0 and is reset to 0 when a new command begins in the Command Phase.
    let sequenceID: Int
    
    /// payload of the packet
    let payload: Bytes
    
    init(data: Data) throws {
        let buffer = Buffer(data: data)
        
        let header = buffer.readNext(need: 4)
        
        let u1 = UInt32(header[0])
        let u2 = UInt32(header[1]) << 8
        let u3 = UInt32(header[2]) << 16
        let pktLen = Int(u1 | u2 | u3)
        
        guard pktLen > 0 else {
            throw Err.ErrInvalidConn
        }
        
        let bytes = buffer.readNext(need: pktLen)
        
        self.payloadLength = pktLen
        self.sequenceID = Int(header[3])
        self.payload = bytes
    }
    
//    static func read(socket: Socket) throws -> Packet {
//        var data = Data()
//        let result = try socket.read(into: &data)
//
//        guard result > 0 else {
//            throw Err.ErrInvalidConn
//        }
//
//        let buffer = Buffer(data: data)
//        let packet = try Packet(buffer: buffer)
//
//        return packet
//    }
}

//extension Stream {
//    func readHandshakePacket() throws -> (handshake: Handshake, packnr: Packnr) {
//        let data = try readPacket()
//
//        let handshake = Handshake(bytes: data.bytes)
//        if handshake.protoVersion == iERR {
//            // TODO
//        }
//        if handshake.protoVersion < minProtocolVersion {
//            // TODO
//        }
//
//        return (handshake, data.packnr)
//    }
//}

//
//  Stream.swift
//  MySQLDriver
//
//  Created by Li Xiaoyu on 2019/1/7.
//

import Foundation
import Socket

class Stream {
    let socket: Socket
    var sequence: Int = 0
    
    init(address: String, port: Int32) throws {
        self.socket = try Socket.create()
        try self.socket.connect(to: address, port: port)
    }
    
    func read() throws -> Packet {
        var data = Data()
        let len = try socket.read(into: &data)
        guard len > 0 else {
            throw Err.ErrInvalidResponse
        }
        
        let packet = try Packet(data: data)
        
        self.sequence = packet.sequenceID
        
        return packet
    }
    
    func write(payload: Bytes) throws {
        let writedPacket = Packet(
            pktLen: payload.count,
            sequenceID: sequence + 1,
            payload: payload
        )
        try socket.write(from: writedPacket.writeBytes())
    }
    
    func resetSequence() {
        sequence = 0
    }
}

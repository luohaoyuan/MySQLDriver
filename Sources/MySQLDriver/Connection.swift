//
//  Connection.swift
//  MySQLDriver
//
//  Created by iCell on 2018/12/9.
//

import Foundation
import Socket

class Connection {
    let config: Config
    let sequence: Byte = 0
    
    init(config: Config) {
        self.config = config
    }
    
    func connect() throws {
        do {
            let socket = try Socket.create()
            try socket.connect(to: config.address, port: config.port)
            
//            let packet = try Packet.readPacket(socket: socket)
            
//            let packet = try stream.readHandshakePacket()
//            print(packet.handshake.authData)
//            print(packet.packnr)
            
        } catch {
            print(error)
        }
    }
}

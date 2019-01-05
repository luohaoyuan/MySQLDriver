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
            
            var data = Data()
            let len = try socket.read(into: &data)
            guard len > 0 else {
                return
            }
            
            let packet = try Packet(data: data)
            let handshake = try Handshake(payload: packet.payload)
            print(handshake)
        } catch {
            print(error)
        }
    }
}

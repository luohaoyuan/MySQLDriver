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
    
    init(config: Config) {
        self.config = config
    }
    
    func connect() throws {
        do {
            let stream = try Stream(address: config.address, port: config.port)
            
            let handshake = try stream.readHandshake()
            try stream.writeHandshake(handshake)
            
            try stream.handleAuth(
                scramble: handshake.scramble,
                plugin: handshake.plugin,
                password: config.password
            )

        } catch {
            print(error)
        }
    }
}

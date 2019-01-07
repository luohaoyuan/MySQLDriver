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
            let stream = try Stream.init(address: config.address, port: config.port)
            
            let handshake = try stream.read().handshake()
            let authPayload = handshake.authPayload(config: config)
            
            try stream.write(payload: authPayload)
            
            let authRes = try stream.read()
            
            print(authRes)
        } catch {
            print(error)
        }
    }
}

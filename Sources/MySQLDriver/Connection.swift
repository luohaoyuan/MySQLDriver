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
            
            let handshake = try stream.read().handshake()
            let authPayload = handshake.authPayload(config: config)
            
            try stream.write(payload: authPayload)
            
            let authResPayload = try stream.read().payload
            
            switch authResPayload[0] {
            case ResultHeader.ok.rawValue:
                let okPacketBytes =  Bytes(authResPayload[0..<authResPayload.count])
                let okPacket = OKPacket(bytes: okPacketBytes)
                print(okPacket)
            default:
                break
            }
            
        } catch {
            print(error)
        }
    }
}

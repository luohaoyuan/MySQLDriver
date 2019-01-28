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

extension Stream {
    func readHandshake() throws -> Handshake {
        let payload = try read()
        return try Handshake(payload: payload.payload)
    }
    
    func writeHandshake(_ handshake: Handshake) throws {
        let authPayload = handshake.authPayload(config: config)
        try write(payload: authPayload)
    }
    
    func handleAuth(scramble: Bytes, plugin: AuthPlugin, password: String?) throws {
        let res = try readAuthResult()
        
        var scramble = scramble
        var plugin = plugin
        
        if let newPlugin = res.plugin {
            plugin = newPlugin
            
            if let payload = res.payload {
                scramble = payload
            }
            
            let authResp = Auth.auth(scramble: scramble, password: password, plugin: plugin)
            try write(payload: authResp)
            
            _ = try readAuthResult()
        }
        
        switch plugin {
        case .cachingSHA2:
            // TODO: not support currently
            break
        case .sha256:
            // TODO: not support currently
            break
        default:
            return
        }
    }
    
    func readAuthResult() throws -> (payload: Bytes?, plugin: AuthPlugin?) {
        let authResPayload = try read().payload
        guard authResPayload.count > 0 else {
            throw Err.ErrInvalidResponse
        }
        
        switch authResPayload[0] {
        case ResultHeader.ok.rawValue:
            print("ok")
            return (nil, nil)
            
        case ResultHeader.authMoreData.rawValue:
            let authMoreBytes = Bytes(authResPayload[1..<authResPayload.count])
            return (authMoreBytes, nil)
            
        case ResultHeader.eof.rawValue:
            if authResPayload.count == 1 {
                return (nil, .old)
            }
            let buffer = Buffer(bytes: authResPayload)
            
            // FIXME: if no 0x00 existed, maybe crash?
            let pluginStr = buffer.readNextNullTerminatedBytes().string()
            let plugin = AuthPlugin(rawValue: pluginStr)!
            let authData = buffer.readRest()
            return (authData, plugin)
            
        default:
            throw Err.ErrMalformPkt
        }
    }
}

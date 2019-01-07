//
//  Bytes.swift
//  MySQLDriver
//
//  Created by iCell on 2018/12/9.
//

import Foundation
import Socket

typealias Byte = UInt8
typealias Bytes = [Byte]

class Buffer {
    
    var bytes: Bytes
    
    private(set) var index: Int = 0
    private(set) var length: Int
    
    init(bytes: Bytes) {
        self.bytes = bytes
        self.length = self.bytes.count
    }
    
    convenience init(data: Data) {
        self.init(bytes: Bytes(data))
    }
    
    public func readNext(need: Int) -> Bytes {
        let result = bytes[index..<(index + need)]
        index += need
        length -= need
        
        return Bytes(result)
    }
    
    public func readNextByte() -> Byte {
        return readNext(need: 1)[0]
    }
    
    public func readNextNullTerminatedBytes() -> Bytes {
        var result = Bytes()
        
        while index < bytes.count {
            let byte = bytes[index]
            index += 1
            length -= 1
            
            if byte == 0x00 {
                break
            }
            result.append(byte)
        }

        return result
    }
}

extension Array where Iterator.Element == Byte {
    func string() -> String {
        guard let str = String(bytes: self, encoding: .utf8) else {
            return ""
        }
        return str
    }
    
    func uInt16() -> UInt32 {
        return UInt32(self[1]) << 8 | UInt32(self[0])
    }
    
    func uInt24() -> UInt32 {
        return UInt32(self[2]) << 16 | UInt32(self[1]) << 8 | UInt32(self[0])
    }
    
    func uInt32() -> UInt32 {
        let u1 = UInt32(self[0])
        let u2 = UInt32(self[1]) << 8
        let u3 = UInt32(self[2]) << 16
        let u4 = UInt32(self[3]) << 24

        return u4 | u3 | u2 | u1
    }
    
    static func uInt24Array(_ val: UInt32) -> Bytes {
        var bytes = Bytes(repeating: 0, count: 3)
        
        for i in 0...2 {
            bytes[i] = Byte(0x0000FF & val >> UInt32((i) * 8))
        }
        
        return bytes
    }
    
    static func uInt32Array(_ val: UInt32) -> Bytes {
        var bytes = Bytes(repeating:0, count: 4)
        
        for i in 0...3 {
            bytes[i] = Byte(0x0000FF & val >> UInt32((i) * 8))
        }
        
        return bytes
    }
}

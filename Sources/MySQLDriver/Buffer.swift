//
//  Bytes.swift
//  MySQLDriver
//
//  Created by iCell on 2018/12/9.
//

import Foundation
import Socket

typealias Byte = UInt8
typealias Bytes = [UInt8]

class Buffer {
    
    var bytes: Bytes
    
    var index: Int = 0
    var length: Int
    
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

extension Sequence where Iterator.Element == Byte {
    func string() -> String {
        let arr = self.map { $0 }
        guard let str = String(bytes: arr, encoding: .utf8) else {
            return ""
        }
        
        return str
    }
    
    func uInt16() -> UInt16 {
        let arr = self.map { $0 }
        return UInt16(arr[1]) << 8 | UInt16(arr[0])
    }
    
    func uInt24() -> UInt32 {
        let arr = self.map { $0 }
        return UInt32(arr[2]) << 16 | UInt32(arr[1]) << 8 | UInt32(arr[0])
    }
    
    func uInt32() -> UInt32 {
        let arr = self.map { $0 }
        
        let u1 = UInt32(arr[0])
        let u2 = UInt32(arr[1]) << 8
        let u3 = UInt32(arr[2]) << 16
        let u4 = UInt32(arr[3]) << 24

        return u4 | u3 | u2 | u1
    }
}

//
//  Error.swift
//  CryptoSwift
//
//  Created by iCell on 2019/1/5.
//

import Foundation

enum Err: Error {
    case ErrNotSupport
    case ErrInvalidConn
    case ErrInvalidResponse
    case ErrOldProtocol
    case ErrInvalidProtoVersion
    case ErrInvalidHandshake
    case ErrMalformPkt
    case ErrMySQL(code: Int, message: String)
}

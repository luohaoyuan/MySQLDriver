//
//  Error.swift
//  CryptoSwift
//
//  Created by iCell on 2019/1/5.
//

import Foundation

enum Err: Error {
    case ErrInvalidConn
    case ErrOldProtocol
    case ErrInvalidProtoVersion
    case ErrInvalidHandshake
}

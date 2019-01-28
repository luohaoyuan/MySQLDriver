//
//  Const.swift
//  MySQLDriver
//
//  Created by iCell on 2019/1/4.
//

import Foundation

let minProtocolVersion = 10

enum ResultHeader: Byte {
    case ok = 0x00
    case authMoreData = 0x01
    case localInFile = 0xfb
    case eof = 0xfe
    case err = 0xff
}

enum ClientFlag: UInt32 {
    case longPassword = 0x00000001
    case foundRows = 0x00000002
    case longFlag = 0x00000004
    case connectWithDB = 0x00000008
    case noSchema = 0x00000010
    case compress = 0x00000020
    case odbc = 0x00000040
    case localFiles = 0x00000080
    case ignoreSpace = 0x00000100
    case protocol41 = 0x00000200
    case interactive = 0x00000400
    case ssl = 0x00000800
    case ignoreSigpipe = 0x00001000
    case transactions = 0x00002000
    case reserved = 0x00004000
    case secureConnection = 0x00008000
    case multiStatements = 0x00010000
    case multiResults = 0x00020000
    case psMultiResults = 0x00040000
    case pluginAuth = 0x00080000
    case connectAttrs = 0x00100000
    case pluginAuthLenEncClientData = 0x00200000
    case canHandleExpiredPasswords = 0x00400000
    case sessionTrack = 0x00800000
    case deprecateEOF = 0x01000000
}

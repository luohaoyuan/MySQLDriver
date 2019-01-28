//
//  Config.swift
//  MySQLDriver
//
//  Created by iCell on 2018/12/9.
//

import Foundation

struct Config {
    let username: String
    let password: String?
    let address: String
    let port: Int32
    let dbName: String?
    
    let clientFoundRows: Bool
    let multiStatements: Bool
    let collation: Collation
    
    init(username: String,
         password: String?,
         address: String,
         port: Int32 = 3306,
         dbName: String? = nil,
         collation: Collation = Collation.utf8_general_ci,
         clientFoundRows: Bool = false,
         multiStatements: Bool = false
        ) {
        self.username = username
        self.password = password
        self.address = address
        self.port = port
        self.dbName = dbName
        self.clientFoundRows = clientFoundRows
        self.multiStatements = multiStatements
        self.collation = collation
    }
}

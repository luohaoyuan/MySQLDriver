import Foundation
import Socket

let config = Config.init(username: "root", password: nil, address: "127.0.0.1", port: 3306, dbName: "counter_dev")
let conn = Connection(config: config)
try conn.connect()

//
//  DBUser.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/9.
//

import Foundation
import WCDBSwift

class DBUser : TableCodable {
    
    /// 另一个用户的ID
    let toUser:Int

    init(_ toUser:Int) {
        self.toUser = toUser
    }

    
    enum CodingKeys:String,CodingTableKey {
        
        typealias Root = DBUser
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case toUser
    }
    
}

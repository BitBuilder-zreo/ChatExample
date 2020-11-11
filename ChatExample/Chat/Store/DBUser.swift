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
    /// 更新时间
    let latest:Date

    init(_ toUser:Int,
         _ latest:Date = Date()) {
        self.toUser = toUser
        self.latest = latest
    }

    enum CodingKeys:String,CodingTableKey {
        
        typealias Root = DBUser
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case toUser

        case latest

        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                toUser: ColumnConstraintBinding(isPrimary: true,isUnique: true),
            ]
        }

//        static var indexBindings: [IndexBinding.Subfix: IndexBinding]? {
//            return [
//                "_index": IndexBinding(indexesBy: update)
//            ]
//        }
    }
    
}

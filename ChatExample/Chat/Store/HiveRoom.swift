//
//  DBModel.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/9.
//

import Foundation
import WCDBSwift
class HiveRoom {
    
    fileprivate static let Path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory,
        .userDomainMask,
        true).last! + "/Hive.db"
    
    let database:Database
    
    init() {
        database = Database(withPath:HiveRoom.Path)
        
        do {
            try database.create(table: "User", of: DBUser.self)
            try database.create(table: "Message", of: Message.self)
            try database.create(table: "Text", of: Message.TextContent.self)
            try database.create(table: "Image", of: Message.ImageContent.self)
            try database.create(table: "Voice", of: Message.VoiceContent.self)
        } catch {
            print("数据库列表创建失败")
        }
    }
}

extension HiveRoom {
    
    /// 获取全部用户
    /// - Returns:
    func allUser() -> [DBUser] {
        
        let items:[DBUser]? =  try? database.getObjects(fromTable: "User")
        
        return items ?? []
    }
    
}

extension HiveRoom {
    
    
    
}


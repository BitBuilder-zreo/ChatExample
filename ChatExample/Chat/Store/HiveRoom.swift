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

    lazy var items:[ChatMessageFactory] =  {

        return self.allUser().map{ ChatMessageFactory(toUser: $0.toUser) }
    }()
    
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

        let order = DBUser.Properties.latest.asOrder(by: .descending)

        let items:[DBUser]? =  try? database.getObjects(fromTable: "User" ,orderBy: [order])
        
        return items ?? []
    }
    
}

extension HiveRoom {
    

    func allMessage(toUser:Int) ->[Message] {

        let order =  Message.Properties.identifier.asOrder(by: .descending)

        let messages:[Message]? = try? database.getObjects(fromTable:"Message", where: Message.Properties.toUser == toUser,orderBy: [order])

        return messages ?? []
    }

    func insertOrUpdate(_ user:DBUser) {

        try? database.insertOrReplace(objects: user, intoTable: "User")
    }

    func insert(message:Message,text:String) {

        let content = Message.TextContent(context: text)

        try? database.insert(objects: content, intoTable: "Text")

        message.contentID = content.lastInsertedRowID

        try? database.insert(objects: message, intoTable: "Message")
    }

    func makeTextRandomMessage(message:Message) -> String {
        
        guard let conetentID = message.contentID else { return "" }

        let content:Message.TextContent? = try? database.getObject(fromTable: "Text", where:Message.TextContent.Properties.uid == conetentID)

        guard let text = content?.content else { return "" }

        return text
    }

    
}





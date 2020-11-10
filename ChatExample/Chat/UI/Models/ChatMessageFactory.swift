//
//  ChatMessageFactory.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/8.
//

import Foundation
import Chatto
import ChattoAdditions
import WCDBSwift
class ChatMessageFactory {
    
    fileprivate weak var database:Database?
    
    let toUser:Int

    var items:[Message]

    init(_ database:Database = Beehive.default.hive.database,toUser:Int) {
        self.database = database
        self.toUser = toUser

        do {
            items = try database.getObjects(fromTable: "Message", where: toUser == Message.Properties.toUser)

        } catch  {
            items = []
            print("获取数据失败")
        }
    }

    func makeRandomMessage() -> [MessageModelProtocol]  {

        return  items.map { self.makeRandomMessage($0) }
    }

    func makeTextMessage(_ text:String) -> ChatMessageModelProtocol  {

        let user = DBUser(toUser)
        try? database?.insert(objects: user, intoTable: "User")

        let message = Message(toUser: toUser, status: 1, type: 1, isSender: true)

        try? database?.insert(objects: message, intoTable: "Message")

        let content = Message.TextContent(uid: 0, content: text)

        try? database?.insert(objects: content, intoTable: "Text")

        let messageModel = ChatMessageFactory.makeMessageModel(message)

        return ChatTextMessageModel(messageModel: messageModel, text: text)

    }

}


fileprivate extension ChatMessageFactory {

    func makeRandomMessage(_ message:Message) -> MessageModelProtocol {

        switch message.type {
        case 1:
            let text:String
            do {

                let content:Message.TextContent? = try database?.getObject(fromTable: "Text", where: message.identifier ?? 0 == Message.TextContent.Properties.uid)
                text = content?.content ?? ""
            } catch  {
                text = ""
            }

            let messageModel = ChatMessageFactory.makeMessageModel(message)

            return ChatTextMessageModel(messageModel: messageModel, text: text)
        default:
            return MessageModel(uid: "", senderId: "", type: "", isIncoming: false, date: Date(), status: .failed, canReply: false)
        }
    }

    static  func makeMessageModel(_ message:Message) -> MessageModel {

        var messageStatus:MessageStatus

        switch message.status {
        case 1:
            messageStatus = .sending
        case 2:
            messageStatus = .success
        default:
            messageStatus = .failed
        }

        return MessageModel(
            uid:"\(message.identifier ?? 0)",
            senderId:"\(message.toUser)",
            type: TextMessageModel<MessageModel>.chatItemType,
            isIncoming: !message.isSender,
            date: message.date,
            status: messageStatus)
    }

}



extension ChatMessageFactory {
    
    /// update 新的消息
    func update()  {
        
    }
}



extension TextMessageModel {

    static var chatItemType: ChatItemType {
        return "text"
    }
}


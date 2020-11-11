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

    let toUser:Int

    var items:[Message]

    init(toUser:Int) {

        self.toUser = toUser

        items = Beehive.allMessage(toUser: toUser)
    }

    func makeRandomMessage() -> [MessageModelProtocol]  {

        return  items.map { self.makeRandomMessage($0) }
    }

    func makeTextMessage(_ text:String) -> ChatMessageModelProtocol  {

        Beehive.insertOrUpdate(DBUser(toUser))

        let message = Message(toUser: toUser, status: 1, type: 1, isSender: true)

        Beehive.insert(message: message, text: text)

        let messageModel = ChatMessageFactory.makeMessageModel(message)

        return ChatTextMessageModel(messageModel: messageModel, text: text)

    }

}


fileprivate extension ChatMessageFactory {

    func makeRandomMessage(_ message:Message) -> MessageModelProtocol {

        switch message.type {
        case 1:
            let text = Beehive.makeTextRandomMessage(message: message)

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


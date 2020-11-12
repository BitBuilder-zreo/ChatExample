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

    typealias MessageReceived = (MessageModelProtocol)->()

    let toUser:String

    var items:[Message]

    var received : MessageReceived?

    init(toUser:String) {

        self.toUser = toUser

        items = Beehive.allMessage(toUser: toUser)
    }

    func makeRandomMessage() -> [MessageModelProtocol]  {

        return items.map { self.makeRandomMessage($0) }
    }

    func makeTextMessage(_ text:String) -> ChatMessageModelProtocol  {

        Beehive.insertOrUpdate(DBUser(toUser))

        let message = Message(toUser: toUser, status: 1, type: 1, isSender: true)

        Beehive.insert(message: message, text: text)

        let messageModel = ChatMessageFactory.makeMessageModel(message)

        return ChatTextMessageModel(messageModel: messageModel, text: text)

    }

    func update(message:Message) {

        self.received?(makeRandomMessage(message))
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


extension TextMessageModel {

    static var chatItemType: ChatItemType {
        return "text"
    }
}


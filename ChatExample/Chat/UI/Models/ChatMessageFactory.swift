//
//  ChatMessageFactory.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/8.
//

import Foundation
import Chatto
import ChattoAdditions
class ChatMessageFactory {

    let toUser:Int

    init(_ toUser:Int) {
        self.toUser = toUser
    }

    func makeRandomMessage(_ uid: String) -> MessageModelProtocol {

        return makeRandomMessage(uid,isIncoming: true)
    }

     func makeRandomMessage(_ uid: String, isIncoming: Bool) -> MessageModelProtocol {

        return makeRandomTextMessage(uid, isIncoming: isIncoming)
    }

    func makeRandomTextMessage(_ uid: String, isIncoming: Bool) -> ChatTextMessageModel {

        let text = "11232131"

        return self.makeTextMessage(uid, text: text, isIncoming: isIncoming)
    }

     func makeTextMessage(_ uid: String, text: String, isIncoming: Bool) -> ChatTextMessageModel {
        let messageModel = makeMessageModel(uid, isIncoming: isIncoming, type: TextMessageModel<MessageModel>.chatItemType)
        let textMessageModel = ChatTextMessageModel(messageModel: messageModel, text: text)
        return textMessageModel
    }

     func makeMessageModel(_ uid: String, isIncoming: Bool, type: String, status: MessageStatus? = nil) -> MessageModel {
        let senderId = isIncoming ? "1" : "2"
        let messageStatus: MessageStatus = {
            guard !isIncoming else { return .success }
            guard let status = status else { return (arc4random_uniform(100) % 3 == 0) ? .success : .failed }
            return status
        }()
        return MessageModel(
            uid: uid,
            senderId: senderId,
            type: type,
            isIncoming: isIncoming,
            date: Date(),
            status: messageStatus,
            canReply: true
        )
    }

}

extension TextMessageModel {
    static var chatItemType: ChatItemType {
        return "text"
    }
}


//
//  ChatTextMessageModel.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/9.
//

import Foundation
import Chatto
import ChattoAdditions

class ChatTextMessageModel: TextMessageModel<MessageModel>, ChatMessageModelProtocol {
    override init(messageModel: MessageModel, text: String) {
        super.init(messageModel: messageModel, text: text)
    }
    
    var status: MessageStatus {
        get {
            return self._messageModel.status
        }
        set {
            self._messageModel.status = newValue
        }
    }
}

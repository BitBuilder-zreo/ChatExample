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
    
    
    class func makeRandomMessage(uid:Int) -> ChatTextMessageModel {
        
        let message = MessageModel(uid: String(uid), senderId: "uid", type: "asda", isIncoming: false, date: Date(), status: .success)
    
        return ChatTextMessageModel(messageModel: message, text: "11111")
    }
    
}


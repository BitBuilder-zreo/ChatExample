//
//  TextMessageModel.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/9.
//

import Foundation
import Chatto
import ChattoAdditions

/// 文本协议
protocol TextMessageModelProtocol: DecoratedMessageModelProtocol, ContentEquatableChatItemProtocol {
    
    var text: String { get }
}

class TextMessageModel<T:MessageModelProtocol>:TextMessageModelProtocol {
    
    let _messageModel: T
    
    var canReply: Bool { self.messageModel.canReply }
    
    var messageModel: MessageModelProtocol { return self._messageModel }
    
    let text: String
    
    init(messageModel: T, text: String) {
        self._messageModel = messageModel
        self.text = text
    }
    
    func hasSameContent(as anotherItem: ChatItemProtocol) -> Bool {
        
        guard let anotherMessageModel = anotherItem as? TextMessageModel else { return false }
        
        return self.text == anotherMessageModel.text
    }
}

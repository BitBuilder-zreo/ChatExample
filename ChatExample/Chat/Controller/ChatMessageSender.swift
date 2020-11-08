//
//  ChatMessageSender.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/9.
//

import Foundation
import Chatto
import ChattoAdditions

public protocol ChatMessageModelProtocol: MessageModelProtocol, ContentEquatableChatItemProtocol {
    var status: MessageStatus { get set }
}

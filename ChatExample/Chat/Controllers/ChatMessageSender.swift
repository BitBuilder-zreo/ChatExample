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
class ChatMessageSender {

    var onMessageChanged: ((_ message: ChatMessageModelProtocol) -> Void)?

    func sendMessages(_ messages: [ChatMessageModelProtocol]) {
        for message in messages {
            self.fakeMessageStatus(message)
        }
    }

    func sendMessage(_ message: ChatMessageModelProtocol) {
        self.fakeMessageStatus(message)
    }

    /// 发送成功 失败
    private func fakeMessageStatus(_ message: ChatMessageModelProtocol) {
        switch message.status {
        case .success:
            break
        case .failed:
            self.updateMessage(message, status: .sending)
            self.fakeMessageStatus(message)
        case .sending:
            switch arc4random_uniform(100) % 5 {
            case 0:
                if arc4random_uniform(100) % 2 == 0 {
                    self.updateMessage(message, status: .failed)
                } else {
                    self.updateMessage(message, status: .success)
                }
            default:
                let delaySeconds: Double = Double(arc4random_uniform(1200)) / 1000.0
                let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.fakeMessageStatus(message)
                }
            }
        }
    }

    private func updateMessage(_ message: ChatMessageModelProtocol, status: MessageStatus) {
        if message.status != status {
            message.status = status
            self.notifyMessageChanged(message)
        }
    }

    private func notifyMessageChanged(_ message: ChatMessageModelProtocol) {
        self.onMessageChanged?(message)
    }
}

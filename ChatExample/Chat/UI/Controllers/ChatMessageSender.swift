//
//  ChatMessageSender.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/9.
//

import Foundation
import Chatto
import ChattoAdditions
import Moya
import RxSwift
public protocol ChatMessageModelProtocol: MessageModelProtocol, ContentEquatableChatItemProtocol {
    var status: MessageStatus { get set }
}
class ChatMessageSender {
    
    let bag = DisposeBag()
    
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
        
        if let model = message as? ChatTextMessageModel {

            switch message.status {
            case .success:
                break
            case .failed:
                self.updateMessage(message, status: .sending)
                self.sendMessage(message)
            case .sending:
                let text =  Api.Message.text(value: model.text)
                
                let provider:MoyaProvider<Api> = MoyaProvider()
                
                provider.rx.request(.send(id: message.senderId, message: text)).subscribe { (response) in
                    
                    self.updateMessage(message, status: .success)
                    
                } onError: { (error) in
                    
                    self.updateMessage(message, status: .failed)
                }.disposed(by: bag)
                
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

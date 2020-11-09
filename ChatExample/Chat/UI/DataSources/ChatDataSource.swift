//
//  ChatDataSource.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/8.
//

import Foundation
import Chatto

class ChatDataSource {

    var nextMessageId: Int = 0

    let preferredMaxWindowSize = 500

    /// 数据源代理
    weak var delegate: ChatDataSourceDelegateProtocol?

    /// 数据滑动代理
    var slidingWindow:SlidingDataSource<ChatItemProtocol>!

    lazy var messageSender: ChatMessageSender = {
        let sender = ChatMessageSender()
        sender.onMessageChanged = { [weak self] (message) in
            guard let sSelf = self else { return }
            sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
        }
        return sender
    }()

    let factory:ChatMessageFactory!

    init(factory:ChatMessageFactory,count:Int,pageSize:Int) {
        self.factory = factory
        self.slidingWindow = SlidingDataSource(count: count, pageSize: pageSize, itemGenerator: { [weak self]() -> ChatItemProtocol in

            guard let sSelf = self else { return factory.makeRandomMessage("") }

            defer { sSelf.nextMessageId += 1 }

            return factory.makeRandomMessage(String(sSelf.nextMessageId))
        })
    }
}

extension ChatDataSource : ChatDataSourceProtocol{

    /// 判断有没有下一个
    var hasMoreNext: Bool {
        return slidingWindow.hasMore()
    }

    /// 判断有没有上一个
    var hasMorePrevious: Bool {
        return slidingWindow.hasPrevious()
    }
    
    var chatItems: [ChatItemProtocol] {
        print(slidingWindow.itemsInWindow)
        return slidingWindow.itemsInWindow
    }
    
    func loadNext() {
        slidingWindow.loadNext()
        slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: preferredMaxWindowSize)
        delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
        
    }
    
    func loadPrevious() {
        slidingWindow.loadPrevious()
        slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: preferredMaxWindowSize)
        delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: (Bool) -> Void) {

        let didAdjust = slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? preferredMaxWindowSize)

        completion(didAdjust)
    }

}

extension ChatDataSource {

    func addTextMessage(_ text:String)  {

        let uid = "\(self.nextMessageId)"
        self.nextMessageId += 1
        let message = factory.makeTextMessage(uid, text: text, isIncoming: false)
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)

        delegate?.chatDataSourceDidUpdate(self)
    }


}




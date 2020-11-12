//
//  ChatDataSource.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/8.
//

import Foundation
import Chatto
import RxSwift
import Moya

class ChatDataSource {
    
    let bag = DisposeBag()
    
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
    
    init(factory:ChatMessageFactory,pageSize:Int) {
        
        self.factory = factory
        
        let items:[ChatItemProtocol] = factory.makeRandomMessage()
        
        self.slidingWindow = SlidingDataSource(items: items, pageSize: 50)

        factory.received = { [weak self] (message) in

            if let sSelf = self {

                sSelf.slidingWindow.insertItem(message, position: .bottom)
                sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
                sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
            }
        }
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
        
        let message = factory.makeTextMessage(text)
        
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
        delegate?.chatDataSourceDidUpdate(self)
    }
    
    
}




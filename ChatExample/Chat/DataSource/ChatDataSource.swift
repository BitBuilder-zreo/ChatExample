//
//  ChatDataSource.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/8.
//

import Foundation
import Chatto

class ChatDataSource {
    
    /// 数据源代理
    weak var delegate: ChatDataSourceDelegateProtocol?
    
    /// 数据滑动代理
    var slidingWindow:SlidingDataSource<ChatItemProtocol>!
    
    /// 目标 id
    let toUser:Int
    
    /// 自己的头像
    let headImage:String
    
    init(toUser:Int,headImage:String,count:Int,pageSize:Int) {
        self.toUser = toUser
        self.headImage = headImage
        
        self.slidingWindow = SlidingDataSource(count: count, pageSize: pageSize, itemGenerator: { () -> ChatItemProtocol in
          
            return ChatMessageFactory.makeRandomMessage(uid: toUser)
        })
    }
}

extension ChatDataSource : ChatDataSourceProtocol{
    
    var hasMoreNext: Bool {
        
        return slidingWindow.hasMore()
    }
    
    var hasMorePrevious: Bool {
        return slidingWindow.hasPrevious()
    }
    
    var chatItems: [ChatItemProtocol] {
        return slidingWindow.itemsInWindow
    }
    
    func loadNext() {
        
        slidingWindow.loadNext()
        
    }
    
    func loadPrevious() {
        slidingWindow.loadPrevious()
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: (Bool) -> Void) {
        
    }
    
}


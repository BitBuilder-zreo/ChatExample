//
//  ChatViewController.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/8.
//

import UIKit
import Chatto
import ChattoAdditions
/// https://github.com/badoo/Chatto/wiki
class ChatViewController: BaseChatViewController {
    
    /// Keyboard item 展示器
    fileprivate var chatInputPresenter:BasicChatInputBarPresenter!
    
    /// 数据源
    var dataSource:ChatDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
    }
    
    /// 创建交互构建
    /// - Returns:
    override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
        
        return [ChatItemType:[ChatItemPresenterBuilderProtocol]]()
    }
    
    /// 创建输入框
    /// - Returns:
    override func createChatInputView() -> UIView {
        
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = "发送"
        appearance.textInputAppearance.placeholderText = "请输入内容..."
        self.chatInputPresenter = BasicChatInputBarPresenter(
            chatInputBar: chatInputView,
            chatInputItems:chatInputItems(),
            chatInputBarAppearance: appearance)
        
        chatInputView.maxCharactersCount = 1000
        
        return chatInputView
    }
    
}

fileprivate extension ChatViewController {
    
    /// keyboard 输入项
    /// - Returns:
    func chatInputItems() -> [ChatInputItemProtocol] {
        
        return [textInputItem(),photoInputItem()]
    }
    
    /// keyboard 文字输入
    /// - Returns:
    func textInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            // Your handling code
        }
        return item
    }
    
    /// keyboard 照片输入
    /// - Returns:
    func photoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image,_ in
            // Your handling code
        }
        return item
    }
    
}

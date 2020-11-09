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

    fileprivate var messageSender: ChatMessageSender!

    fileprivate let messagesSelector = BaseMessagesSelector()
    
    /// 数据源
    var dataSource:ChatDataSource!{
        didSet{
            chatDataSource = dataSource
            messageSender = dataSource.messageSender
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        cellPanGestureHandlerConfig.allowReplyRevealing = true
        messagesSelector.delegate = self
        chatItemsDecorator = ChatItemsDecorator(messagesSelector: messagesSelector)
        replyActionHandler = ChatReplyActionHandler(presentingViewController: self)
      
    }

    
    /// 构建消息类型
    /// - Returns:
    override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {

        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: ChatTextMessageViewModelBuilder(),
            interactionHandler: ChatMessageInteractionHandler(
                messageSender: messageSender,
                messagesSelector: messagesSelector)
        )

        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()

        return [ChatTextMessageModel.chatItemType:[textMessagePresenter]]
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
            self?.dataSource.addTextMessage(text)
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

extension ChatViewController : MessagesSelectorDelegate {

    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        enqueueModelUpdate(updateType: .normal)
    }

    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        enqueueModelUpdate(updateType: .normal)
    }

}

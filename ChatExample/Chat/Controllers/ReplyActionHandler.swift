//
//  ReplyActionHandler.swift
//  ChatExample
//
//  Created by W&Z on 2020/11/9.
//

import Chatto

final class ChatReplyActionHandler: ReplyActionHandler {

    private weak var presentingViewController: UIViewController?

    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }

    func handleReply(for: ChatItemProtocol) {
        let alert = UIAlertController(
            title: "Reply message with swipe",
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        presentingViewController?.present(alert, animated: true, completion: nil)
    }
}

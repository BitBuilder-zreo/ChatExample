//
//  BaseMessagesSelector.swift
//  ChatExample
//
//  Created by W&Z on 2020/11/9.
//

import Foundation
import ChattoAdditions

protocol MessagesSelectorDelegate: class {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol)
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol)
}

protocol MessagesSelectorProtocol: class {
    var delegate: MessagesSelectorDelegate? { get set }
    var isActive: Bool { get set }
    func canSelectMessage(_ message: MessageModelProtocol) -> Bool
    func isMessageSelected(_ message: MessageModelProtocol) -> Bool
    func selectMessage(_ message: MessageModelProtocol)
    func deselectMessage(_ message: MessageModelProtocol)
    func selectedMessages() -> [MessageModelProtocol]
}


class BaseMessagesSelector: MessagesSelectorProtocol {

    weak var delegate: MessagesSelectorDelegate?

    var isActive = false {
        didSet {
            guard oldValue != self.isActive else { return }
            if self.isActive {
                self.selectedMessagesDictionary.removeAll()
            }
        }
    }

    public func canSelectMessage(_ message: MessageModelProtocol) -> Bool {
        return true
    }

    public func isMessageSelected(_ message: MessageModelProtocol) -> Bool {
        return self.selectedMessagesDictionary[message.uid] != nil
    }

    public func selectMessage(_ message: MessageModelProtocol) {
        self.selectedMessagesDictionary[message.uid] = message
        self.delegate?.messagesSelector(self, didSelectMessage: message)
    }

    public func deselectMessage(_ message: MessageModelProtocol) {
        self.selectedMessagesDictionary[message.uid] = nil
        self.delegate?.messagesSelector(self, didDeselectMessage: message)
    }

    public func selectedMessages() -> [MessageModelProtocol] {
        return Array(self.selectedMessagesDictionary.values)
    }

    // MARK: - Private

    private var selectedMessagesDictionary = [String: MessageModelProtocol]()
}

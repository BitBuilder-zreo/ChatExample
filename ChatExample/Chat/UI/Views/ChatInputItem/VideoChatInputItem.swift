//
//  VideoChatInputItem.swift
//  ChatExample
//
//  Created by W&Z on 2020/11/12.
//

import Foundation
import ChattoAdditions


class VideoChatInputItem {

    private(set) var supportsExpandableState: Bool = false

    private(set) var expandedStateTopMargin: CGFloat = 0.0

    var selected: Bool  = false

    private let internalTabView: UIButton

     var inputHandler: (() -> Void)?

    init(buttonAppearance:TabInputButtonAppearance) {

        self.internalTabView = TabInputButton.makeInputButton(withAppearance: buttonAppearance, accessibilityID: "photos.chat.input.view")

        self.internalTabView.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
    }


}

extension VideoChatInputItem {

    @objc fileprivate func buttonEvent(){

        inputHandler?()
    }
}


extension VideoChatInputItem : ChatInputItemProtocol {


    var tabView: UIView { return internalTabView }

    var inputView: UIView? { return nil }

    var presentationMode: ChatInputItemPresentationMode { return .none }

    var showsSendButton: Bool { return false }

    var shouldSaveDraftMessage: Bool { return true }

    func handleInput(_ input: AnyObject) {

    }

}

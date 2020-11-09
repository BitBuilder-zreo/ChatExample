//
//  SendingStatusModel.swift
//  ChatExample
//
//  Created by W&Z on 2020/11/9.
//

import Foundation
import Chatto
import ChattoAdditions

class SendingStatusModel: ChatItemProtocol {
    let uid: String
    static var chatItemType: ChatItemType {
        return "decoration-status"
    }

    var type: String { return SendingStatusModel.chatItemType }
    let status: MessageStatus

    init (uid: String, status: MessageStatus) {
        self.uid = uid
        self.status = status
    }
}

public class SendingStatusPresenterBuilder: ChatItemPresenterBuilderProtocol {

    public func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is SendingStatusModel ? true : false
    }

    public func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        return SendingStatusPresenter(
            statusModel: chatItem as! SendingStatusModel
        )
    }

    public var presenterType: ChatItemPresenterProtocol.Type {
        return SendingStatusPresenter.self
    }
}

class SendingStatusPresenter: ChatItemPresenterProtocol {

    let statusModel: SendingStatusModel
    init (statusModel: SendingStatusModel) {
        self.statusModel = statusModel
    }

    static func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "SendingStatusCollectionViewCell", bundle: Bundle(for: self)), forCellWithReuseIdentifier: "SendingStatusCollectionViewCell")
    }

    let isItemUpdateSupported = false

    func update(with chatItem: ChatItemProtocol) {}

    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendingStatusCollectionViewCell", for: indexPath)
        return cell
    }

    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let statusCell = cell as? SendingStatusCollectionViewCell else {
            assert(false, "expecting status cell")
            return
        }

        let attrs = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0),
            NSAttributedString.Key.foregroundColor: self.statusModel.status == .failed ? UIColor.red : UIColor.black
        ]
        statusCell.text = NSAttributedString(
            string: self.statusText(),
            attributes: attrs)
    }

    func statusText() -> String {
        switch self.statusModel.status {
        case .failed:
            return NSLocalizedString("Sending failed", comment: "")
        case .sending:
            return NSLocalizedString("Sending...", comment: "")
        default:
            return ""
        }
    }

    var canCalculateHeightInBackground: Bool {
        return true
    }

    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 19
    }
}

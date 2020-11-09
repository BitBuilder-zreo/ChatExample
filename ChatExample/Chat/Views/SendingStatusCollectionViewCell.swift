//
//  SendingStatusCollectionViewCell.swift
//  ChatExample
//
//  Created by W&Z on 2020/11/9.
//

import Foundation
import UIKit
class SendingStatusCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var label: UILabel!

    var text: NSAttributedString? {
        didSet {
            self.label.attributedText = self.text
        }
    }
}

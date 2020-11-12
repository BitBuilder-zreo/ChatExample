//
//  VideoChatViewController.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/12.
//

import Foundation
import UIKit
import AgoraRtmKit

class VideoChatViewController: UIViewController {
    
    fileprivate let token:String
    
    fileprivate let uid : Int
    
    fileprivate let toUser:String
    
    fileprivate let chatID:Int
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    init(_ toUser:String,chatID:Int,token:String,uid:Int) {
        self.token = token
        self.uid = uid
        self.toUser = toUser
        self.chatID = chatID
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xx = AgoraRtmLocalInvitation(calleeId: toUser)
        
        
        Beehive.call?.send(xx, completion: { (code) in
            print(code.rawValue)
        })
    }
    
    
    
    
    
}

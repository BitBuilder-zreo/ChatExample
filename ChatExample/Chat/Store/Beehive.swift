//
//  Beehive.swift
//  App
//
//  Created by W&Z on 2020/11/7.
//  Copyright © 2020 W&Z. All rights reserved.
//

import Foundation
import AgoraRtmKit
import AgoraRtcKit

extension Notification.Name {

    static let CallStart = Notification.Name(rawValue: "开始通话")
    static let CallRefuse = Notification.Name(rawValue: "拒绝通话")
    static let CallError  = Notification.Name(rawValue: "邀请错误")
    static let CallCancel  = Notification.Name(rawValue: "邀请取消")
    static let CallRequest = Notification.Name(rawValue: "通话请求")
}




class Beehive : NSObject {
    
    private static let instance = Beehive()
    
    private var chat : AgoraRtmKit?
    
    private var hive:HiveRoom!
    
    private lazy var _items : [ChatMessageFactory] = {
        
        return Beehive.default.hive.allUser().map { ChatMessageFactory(toUser: $0.toUser) }
    }()
    
    class var `default`: Beehive{
        return instance
    }
    
    class var call: AgoraRtmCallKit? {
        
        return Beehive.default.chat?.getRtmCall()
    }
    
    private override init() {
        super.init()
        hive = HiveRoom()
        
    }
    
}

extension Beehive {
    
    /// 登录声网
    /// - Parameter appid: 声网创建的appid
    class func connection(with appid:String)  {
        Beehive.default.chat = AgoraRtmKit(appId:appid , delegate: Beehive.default)

        call?.callDelegate = Beehive.default
        
    }
    
    /// 用户登录
    /// - Parameters:
    ///   - token: 传入能标识用户角色和权限的 token 如果安全要求不高，也可以将值设为 "nil"。token 需要在应用程序的服务器端生成。详见：https://docs.agora.io/cn/Real-time-Messaging/rtm_token?platform=All%20Platforms
    ///   - id: 用户ID
    ///   - completion: 登录回调
    /// - Returns:
    class func login(with token:String? = nil ,id:String,completion:((AgoraRtmLoginErrorCode)->())? = nil)  {
        
        Beehive.default.chat?.login(byToken: token, user: id, completion: completion)
    }
    
    /// 退出登录
    class func logout(with completion:((AgoraRtmLogoutErrorCode)->())? = nil)  {
        
        Beehive.default.chat?.logout(completion: completion)
    }
    
}

extension Beehive : AgoraRtmDelegate {
    
    /// IM连接状态
    /// - Parameters:
    ///   - kit: 实例
    ///   - state: 状态
    ///   - reason: 原因
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        
        switch reason {
        case .login:
            print("登录中")
        case .loginSuccess:
            print("登录成功")
        case .loginFailure:
            print("登录失败")
        default:
            break;
        }
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {

        print("message -> \(message.text)")
        
        guard  let data = message.text.data(using: .utf8) else { return }
        
        Beehive.insertOrUpdate(DBUser(peerId))
        
        if let content = try? JSONDecoder().decode(MessageContent.self, from:data)  {
            
            let message = Message(
                toUser: peerId,
                status: 2,
                type: content.type,
                isSender: false,
                isRead: false)
            if content.type == 1 {
                
                Beehive.insert(message: message, text: content.content)
            }
            
            let contains = Beehive.items.last { $0.toUser == peerId }
            if let factory = contains  {
                
                factory.update(message: message)
                
            }else {
                Beehive.default._items.insert(ChatMessageFactory(toUser: peerId), at: 0)
            }
        }
    }
    
}


extension Beehive {
    
    class var items:[ChatMessageFactory] {
        
        return Beehive.default._items
    }
    
    class func allMessage(toUser:String) ->[Message] {
        
        return Beehive.default.hive.allMessage(toUser: toUser)
    }
    
    class func insertOrUpdate(_ user:DBUser) {
        
        return Beehive.default.hive.insertOrUpdate(user)
    }
    
    class func updateMessage(status:Int,identifier:Int64) {
        
        Beehive.default.hive.updateMessage(status: status, identifier: identifier)
    }
    
    class func insert(message:Message,text:String) {
        
        return Beehive.default.hive.insert(message: message, text: text)
    }
    
    class func makeTextRandomMessage(message:Message) -> String {
        
        return Beehive.default.hive.makeTextRandomMessage(message: message)
    }
    
}

extension Beehive : AgoraRtmCallDelegate {

    /// 收到一个呼叫邀请
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationReceived remoteInvitation: AgoraRtmRemoteInvitation) {

        NotificationCenter.default.post(Notification(name: .CallRequest, object: remoteInvitation))
    }

    /// 接受呼叫邀请成功。
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationAccepted remoteInvitation: AgoraRtmRemoteInvitation) {
        NotificationCenter.default.post(Notification(name: .CallStart))
    }

    /// 拒绝呼叫邀请成功。
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationRefused remoteInvitation: AgoraRtmRemoteInvitation) {
        NotificationCenter.default.post(Notification(name: .CallCancel))
    }

    ///呼叫邀请已被取消。
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationCanceled localInvitation: AgoraRtmLocalInvitation) {
        NotificationCenter.default.post(Notification(name: .CallCancel))
    }

    /// 主叫已取消呼叫邀请。
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationCanceled remoteInvitation: AgoraRtmRemoteInvitation) {
        NotificationCenter.default.post(Notification(name: .CallCancel))
    }

    ///被叫已拒绝呼叫邀请。
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationRefused localInvitation: AgoraRtmLocalInvitation, withResponse response: String?) {
        NotificationCenter.default.post(Notification(name: .CallCancel))
    }
    /// 被叫已接受呼叫邀请。
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationAccepted localInvitation: AgoraRtmLocalInvitation, withResponse response: String?) {
        NotificationCenter.default.post(Notification(name: .CallStart))
    }
    /// 呼叫邀请发送失败。
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationFailure localInvitation: AgoraRtmLocalInvitation, errorCode: AgoraRtmLocalInvitationErrorCode) {
        NotificationCenter.default.post(Notification(name: .CallError))
    }
    /// 来自对端的邀请失败。
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationFailure remoteInvitation: AgoraRtmRemoteInvitation, errorCode: AgoraRtmRemoteInvitationErrorCode) {
        NotificationCenter.default.post(Notification(name: .CallError))
    }
    
    
}

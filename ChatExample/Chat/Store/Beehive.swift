//
//  Beehive.swift
//  App
//
//  Created by W&Z on 2020/11/7.
//  Copyright © 2020 W&Z. All rights reserved.
//

import Foundation
import AgoraRtmKit
class Beehive : NSObject {
    
    private static let instance = Beehive()
    
    private var chat : AgoraRtmKit?
    
    private var hive:HiveRoom!

    class var `default`: Beehive{
        return instance
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
        

    }
    
}


extension Beehive {

    class var items:[ChatMessageFactory]{

        return Beehive.default.hive.allUser().map { ChatMessageFactory(toUser: $0.toUser) }
    }

    class func allMessage(toUser:Int) ->[Message] {

        return Beehive.default.hive.allMessage(toUser: toUser)
    }

    class func insertOrUpdate(_ user:DBUser) {

        return Beehive.default.hive.insertOrUpdate(user)
    }

    class func insert(message:Message,text:String) {

        return Beehive.default.hive.insert(message: message, text: text)
    }

    class func makeTextRandomMessage(message:Message) -> String {

        return Beehive.default.hive.makeTextRandomMessage(message: message)
    }

}

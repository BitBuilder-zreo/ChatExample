//
//  MessageModel.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/9.
//

import Foundation
import WCDBSwift

class Message : TableCodable {
    
    var identifier:Int? = nil
    
    /// 另一个用户的ID
    let toUser:Int
    /// 状态 1发送中 2成功 3失败
    var status:Int
    /// 是否是发送者
    let isSender:Bool
    /// 时间
    let date:Date
    /// 消息类型 1文本 2图片 3语音
    let type:Int
    /// 已读未读
    let isRead:Bool
    
    enum CodingKeys:String,CodingTableKey {
        
        typealias Root = Message
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case toUser
        case status
        case isSender
        case date
        case type
        case isRead
        case identifier
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(isPrimary: true),
            ]
        }
    }
    
}

extension Message {
    
    struct TextContent : TableCodable {
        
        let id:Int
        
        let content:String
        
        enum CodingKeys:String,CodingTableKey {
            typealias Root = TextContent
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            case id
            case content
        }
    }
    
    struct ImageContent:TableCodable {
        
        let id:Int
        
        let url:String
        
        enum CodingKeys:String,CodingTableKey {
            typealias Root = ImageContent
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            case id
            case url
        }
    }
    
    struct VoiceContent:TableCodable {
        let id:Int
        let url:String
        let length:Int
        enum CodingKeys:String,CodingTableKey {
            typealias Root = VoiceContent
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            case id
            case url
            case length
        }
    }
    
    
}


//
//  MessageModel.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/9.
//

import Foundation
import WCDBSwift

class Message : TableCodable {
    
    var identifier:Int64? = nil
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

    var contentID:Int64?

    var isAutoIncrement: Bool { return true }

    var lastInsertedRowID: Int64  = 0 {
        didSet{
            self.identifier = lastInsertedRowID
        }
    }

    init(toUser:Int,
         status:Int,
         type:Int,
         contentID:Int64? = nil,
         isSender:Bool = true,
         isRead:Bool = true,
         date:Date = Date()) {
        self.identifier = Int64.max
        self.toUser = toUser
        self.status = status
        self.isSender = isSender
        self.type = type
        self.isRead = isRead
        self.date = date
        self.contentID = contentID
    }
    
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
        case contentID
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(isPrimary: true),
            ]
        }
    }
    
}

extension Message {
    
    class TextContent : TableCodable {
        
        var uid:Int64? = nil

        let content:String

        var isAutoIncrement: Bool { return true }

        var lastInsertedRowID: Int64  = 0{
            didSet{
                self.uid = lastInsertedRowID
            }
        }

        init(_ uid:Int64? = nil,
             context:String){
            self.uid = uid
            self.content = context
        }
        
        enum CodingKeys:String,CodingTableKey {
            typealias Root = TextContent
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            case uid
            case content
            static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
                return [
                    uid: ColumnConstraintBinding(isPrimary: true)
                ]
            }
        }
    }
    
    struct ImageContent:TableCodable {
        
        let uid:Int
        
        let url:String
        
        enum CodingKeys:String,CodingTableKey {
            typealias Root = ImageContent
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            case uid
            case url
            static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
                return [
                    uid: ColumnConstraintBinding(isPrimary: true),
                ]
            }
        }
    }
    
    struct VoiceContent:TableCodable {
        let uid:Int
        let url:String
        let length:Int
        enum CodingKeys:String,CodingTableKey {
            typealias Root = VoiceContent
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            case uid
            case url
            case length
            static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
                return [
                    uid: ColumnConstraintBinding(isPrimary: true),
                ]
            }
        }
    }
    
    
}


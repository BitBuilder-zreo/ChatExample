//
//  Api.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/11.
//

import Foundation
import Moya
import Alamofire

enum Api {
    case token
    case send(id:String,message:Message)
    case connect(id:String,type:String)
    case rtc(id:String)
    case answer(id:String)
    case chatToken(id:String)
    case hangUp(id:String)
    case end(id:String)
}

extension Api : TargetType {
    var path: String {
        switch self {
        case .token:
            return "v1/sw/getImToken"
        case .send:
            return "v1/im/sendMessage"
        case .rtc:
            return "v1/sw/getChatToken"
        case .connect:
            return "v1/chat/dial"
        case .answer:
            return "/v1/chat/answer"
        case .chatToken:
            return "v1/sw/getChatToken"
        case .hangUp:
            return "v1/chat/hangUp"
        case .end:
            return "v1/chat/end"
        }
    }
    
    var method:Moya.Method { return .post }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .token:
            return .requestPlain
        case let .send(id,message):
            return .requestParameters(
                parameters: ["t_u_id":id,"message":message.entity],
                encoding: JSONEncoding.default)
        case let .connect(id, type):
            return .requestParameters(parameters: ["t_u_id":id,"chat_type":type], encoding:JSONEncoding.default)
        case let .answer(id),
             let .chatToken(id),
             let .hangUp(id),
             let .end(id),
             let .rtc(id):
            return .requestParameters(parameters: ["chat_id":id], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
//        /// 14
//        return [
//            "v":"1.0",
//            "os":"iOS",
//            "token":"1yry0vKYODGi0WwFy685pQTnssJGrmcF"
        
//        ]
//
        /// 11
        return [
            "v":"1.0",
            "os":"iOS",
            "token":"rP023ZJt9d0NkUks5dTxkveQgAo6En1U"
        ]
    }
    
    var baseURL: URL {
        return URL(string: "https://test.yangxiushan.top/chat-api")!
    }
    
}
extension Api {
    
    enum Message {
        case text(value:String)
        case image(value:String)
        
        var entity:String{
            
            var content = [String:Any]()
            
            switch self {
            case let .text(value):
                content["content"] = value
                content["type"] = 1
            case let .image(value):
                content["content"] = value
                content["type"] = 2
                
            }
            
            let json = try! JSONSerialization.data(withJSONObject: content, options:.sortedKeys)
            
            return String(data: json, encoding: .utf8) ?? ""
        }
    }
}

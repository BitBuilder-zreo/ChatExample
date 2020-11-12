//
//  Model.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/11.
//

import Foundation


struct RTMUser : Codable {
    
    let token:String
    
    let u_id:String
    
}

struct MessageContent:Codable {

    let type:Int

    let content:String
}


struct Conversation : Codable {
    
    let chat_id : Int
    
    let sw_token_info: Info
    
}

extension Conversation {
    
    struct Info : Codable {
        
        let token:String
        let u_id:Int
        let channel_name:String        
    }
    
}






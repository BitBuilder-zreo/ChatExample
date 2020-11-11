//
//  Response.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/11.
//

import Foundation
struct Respose<M>:Codable where M : Codable {
    
    let code:Int
    let msg:String?
    let data:M?
}

struct EmptyResponse:Codable {
    
    let code:Int
    
    let msg:String?
}

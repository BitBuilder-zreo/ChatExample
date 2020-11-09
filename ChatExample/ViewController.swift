//
//  ViewController.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/8.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 登录
        Beehive.default.login(id: "10010")
        // Do any additional setup after loading the view.
    }


}

fileprivate extension ViewController  {
    
    @IBAction func addUser(){

//        let factory = ChatMessageFactory(1)
//
//        let chat = ChatViewController()
//
//        chat.dataSource = ChatDataSource(factory: factory, count: 1, pageSize: 50)
//
//        navigationController?.pushViewController(chat, animated: true)
        
    }
    
}



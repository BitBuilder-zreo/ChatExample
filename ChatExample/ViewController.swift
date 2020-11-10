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
        Beehive.default.login(
            with: "006fd8b88f4213e4b0a81a00e01cf4abf17IAABcD0bydUpa0wbJmsA6M5K0cCpd/u6ZeRbUGMgpkjf23cVWtYAAAAAEABYEQEAKoWrXwEA6AMqhatf",
            id: "11")
        // Do any additional setup after loading the view.
    }


}

fileprivate extension ViewController  {
   // http://showdoc.yangxiushan.top/web/#/15?page_id=227
    @IBAction func addUser(){

        let factory = Beehive.default.items.first!

        let chat = ChatViewController()

        chat.dataSource = ChatDataSource(factory: factory,pageSize: 50)

        navigationController?.pushViewController(chat, animated: true)
        
    }
    
}



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
        // Do any additional setup after loading the view.
    }


}

fileprivate extension ViewController  {
    
    @IBAction func addUser(){
        
        let chat = ChatViewController()
        
        navigationController?.pushViewController(chat, animated: true)
        
    }
    
}



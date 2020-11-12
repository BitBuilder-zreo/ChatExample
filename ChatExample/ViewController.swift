//
//  ViewController.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/8.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!

    var items: [ChatMessageFactory] = []
    
    let bag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.items = Beehive.items
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        "token": "rP023ZJt9d0NkUks5dTxkveQgAo6En1U",
//                  "avatar": "https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTI2ypuOuCibDFf8xy6ktq5wZM2iamlkibbib0tv78hoicbdL7XsZMXasiaRvTApuzvHGo64qZcCiavicTiaoyw/132",
//                  "nickname": "用户C8GSZQ"
        
        let provider : MoyaProvider<Api> = MoyaProvider()
        
        provider.rx.request(.token)
            .filterSuccessfulStatusCodes()
            .map(Respose<RTMUser>.self).subscribe { [weak self](response) in
            
                if let user = response.data { self?.login(user: user) }
            } onError: { (error) in
                
            }.disposed(by: bag)

        // Do any additional setup after loading the view.
    }


}

fileprivate extension ViewController  {
   // http://showdoc.yangxiushan.top/web/#/15?page_id=227
    
    func login(user:RTMUser) {
        title = user.u_id
        /// 登录
        Beehive.login(
            with:user.token,
            id: user.u_id)
    }
    
    
    @IBAction func addUser(){

        let factory = ChatMessageFactory(toUser: "14")

        let chat = ChatViewController()

        chat.dataSource = ChatDataSource(factory: factory,pageSize: 50)
        chat.delegate = self

        navigationController?.pushViewController(chat, animated: true)
        
    }
    
}

extension ViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return items.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = String(items[indexPath.row].toUser)

        return cell
    }
    
}

extension ViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let chat = ChatViewController()

        chat.dataSource = ChatDataSource(factory: items[indexPath.row],pageSize: 50)
        chat.delegate = self

        navigationController?.pushViewController(chat, animated: true)

    }
}

extension ViewController : AudioVisualInputDelegate {

    func video(with toUser: String) {

    }

    func audio(with toUer: String) {

    }


}






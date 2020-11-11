//
//  ViewController.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/8.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!

    var items: [ChatMessageFactory] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.items = Beehive.items
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.visibleCells
        /// 登录
        Beehive.login(
            with: "006fd8b88f4213e4b0a81a00e01cf4abf17IAABcD0bydUpa0wbJmsA6M5K0cCpd/u6ZeRbUGMgpkjf23cVWtYAAAAAEABYEQEAKoWrXwEA6AMqhatf",
            id: "11")
        // Do any additional setup after loading the view.
    }


}

fileprivate extension ViewController  {
   // http://showdoc.yangxiushan.top/web/#/15?page_id=227
    @IBAction func addUser(){

        let factory = ChatMessageFactory(toUser: 15)

        let chat = ChatViewController()

        chat.dataSource = ChatDataSource(factory: factory,pageSize: 50)

        navigationController?.pushViewController(chat, animated: true)
        
    }
    
}

extension ViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

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

        navigationController?.pushViewController(chat, animated: true)

    }
}




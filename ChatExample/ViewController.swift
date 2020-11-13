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
import AgoraRtmKit

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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveRemote(notification:)),
            name:.CallRequest, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
}

fileprivate extension ViewController  {
    // http://showdoc.yangxiushan.top/web/#/15?page_id=227
    
    func login(user:RTMUser) {
        title = user.u_id
        print(user.token)
        /// 登录
        Beehive.login(
            with:user.token,
            id: user.u_id)
    }
    
    
    @IBAction func addUser(){
        
     

        let invitation = AgoraRtmLocalInvitation(calleeId: "11")
        invitation.channelId = "1"

        let input = VideoChatViewController.Input(
            token: "",
            uid: "33",
            nickname: "小王",
            avatar:"https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTI2ypuOuCibDFf8xy6ktq5wZM2iamlkibbib0tv78hoicbdL7XsZMXasiaRvTApuzvHGo64qZcCiavicTiaoyw/132",
            channel: "1",
            isSender:true)

        Beehive.call?.send(invitation, completion: { [weak self](code) in

            let video = VideoChatViewController(input)

            video.invitation = invitation

            self?.navigationController?.present(video, animated: true, completion: nil)
        })
        
        
        

//        let provider:MoyaProvider<Api> = MoyaProvider()
//
//        provider.rx.request(.connect(id: "11", type:"1")).filterSuccessfulStatusCodes().map(Respose<Conversation>.self).subscribe { [weak self](response) in
//
//
//
//        } onError: { (error) in
//            print(error)
//        }.disposed(by: bag)



        
        //        let factory = ChatMessageFactory(toUser: "14")
        //
        //        let chat = ChatViewController()
        //
        //        chat.dataSource = ChatDataSource(factory: factory,pageSize: 50)
        //        chat.delegate = self
        //
        //        navigationController?.pushViewController(chat, animated: true)
        
    }
    
    func call(toUser:String, token:String,uid:Int,chat_id:Int)  {
        
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

        let provider:MoyaProvider<Api> = MoyaProvider()
        
        provider.rx.request(.connect(id: toUser, type:"1")).filterSuccessfulStatusCodes().map(Respose<Conversation>.self).subscribe { [weak self](response) in
            
            print(response)
            
        } onError: { (error) in
            print(error)
        }.disposed(by: bag)
        
    }
    
    func audio(with toUer: String) {
        
    }
    
    @objc func receiveRemote(notification:Notification){

        guard let invitation = notification.object as? AgoraRtmRemoteInvitation  else { return }


        //

        let provider:MoyaProvider<Api> = MoyaProvider()

        provider.rx.request(.rtc(id: invitation.channelId ?? "")).filterSuccessfulStatusCodes().map(Respose<Conversation1>.self).subscribe { (response) in

            let data = response.data


            let input = VideoChatViewController.Input(
                token: data?.sw_token_info.token ?? "",
                uid: "11",
                nickname: data?.t_u_info.nickname ?? "",
                avatar: data?.t_u_info.portrait ?? "",
                channel: "1",
                isSender: false)


            let video = VideoChatViewController(input)

            video.remoteInvitation = invitation

            self.navigationController?.present(video, animated: true, completion: nil)

        } onError: { (error) in

        }.disposed(by: bag)



    }
}






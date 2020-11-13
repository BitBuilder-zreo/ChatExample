//
//  VideoChatViewController.swift
//  ChatExample
//
//  Created by 张平战 on 2020/11/12.
//

import Foundation
import UIKit
import AgoraRtmKit
import AgoraRtcKit
import Kingfisher
import Moya
import RxSwift




class VideoChatViewController: UIViewController {
    
    fileprivate let input:Input

    private var rtc : AgoraRtcEngineKit

    @IBOutlet weak var b_imageView:UIImageView!

    @IBOutlet weak var avatar:UIImageView!
    @IBOutlet weak var toNamenick:UILabel!
    @IBOutlet weak var textLabel:UILabel!

    @IBOutlet weak var localVideo:UIView!
    @IBOutlet weak var remoteVideo:UIView!
    @IBOutlet weak var callCancellation:UIButton!
    @IBOutlet weak var callAnswering:UIButton!
    @IBOutlet weak var callcallCancellationTitle:UILabel!
    @IBOutlet weak var mute:UIButton!
    @IBOutlet weak var amplifySound:UIButton!

    var invitation:AgoraRtmLocalInvitation?

    var remoteInvitation:AgoraRtmRemoteInvitation?

    let bag = DisposeBag()

    var isConnected = false

    required init?(coder: NSCoder) {
        fatalError()
    }
    init(_ input:Input) {
        self.input = input
        self.rtc = AgoraRtcEngineKit.sharedEngine(withAppId: "5b29d2e35ebb49d28cd94d594e738892", delegate:nil)
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom

        self.rtc.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configuartion()
        setNotification()
    }

    deinit {
        rtc.leaveChannel(nil)
    }


}

fileprivate extension VideoChatViewController {

    func configuartion()  {
        
        b_imageView.kf.setImage(with: URL(string: input.avatar))
        avatar.kf.setImage(with: URL(string: input.avatar))
        toNamenick.text = input.nickname
        textLabel.text = input.isSender ? "等待接听中" : "邀请你通话"
        callcallCancellationTitle.text = input.isSender ? "挂断" : "拒绝"

        callAnswering.superview?.isHidden = input.isSender
        mute.superview?.isHidden = !input.isSender
        amplifySound.superview?.isHidden = !input.isSender
        
        rtc.setClientRole(.broadcaster)
        rtc.switchCamera()
            
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = localVideo
        videoCanvas.renderMode = .hidden
        // 设置本地视图。
        rtc.setupLocalVideo(videoCanvas)
        
    }

    func setNotification() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(enableSDK),
            name:.CallStart, object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cancelCall),
            name:.CallRefuse, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cancelCall),
            name:.CallError, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cancelCall),
            name:.CallCancel, object: nil
        )

    }

    @objc func enableSDK() {

//        rtc.joinChannel(byUserAccount: input.uid, token: input.token, channelId: input.channel) { (channelID, uid, elapsed) in
//            print(channelID,uid,elapsed)
//        }
        rtc.joinChannel(byUserAccount:input.uid, token: nil, channelId: input.channel) { (channelID, uid, elapsed) in
            
        }
        
        rtc.enableVideo()
        
        rtc.enableAudio()

        callAnswering.superview?.isHidden = true
        mute.superview?.isHidden = false
        amplifySound.superview?.isHidden = false

    }

    /// 拒绝
    @objc func callRefuse(){

        let provider:MoyaProvider<Api> = MoyaProvider()

        provider.rx.request(.hangUp(id: input.channel)).subscribe { (response) in

            if self.input.isSender {

                if let invitation = self.invitation  {
                    Beehive.call?.cancel(invitation, completion: nil)
                }
                self.dismiss(animated: true, completion: nil)
            }else{
                if let invitation = self.remoteInvitation  {
                    Beehive.call?.refuse(invitation, completion: nil)
                }
                self.dismiss(animated: true, completion: nil)
            }

        } onError: { (error) in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)
    }

    @objc func cancelCall(){
        let provider:MoyaProvider<Api> = MoyaProvider()

        provider.rx.request(.hangUp(id: input.channel)).subscribe {[weak self] (response) in

            if self?.input.isSender ?? false {

                if let invitation = self?.invitation  {
                    Beehive.call?.cancel(invitation, completion: nil)
                }
                self?.dismiss(animated: true, completion: nil)
            }else{
                if let invitation = self?.remoteInvitation  {
                    Beehive.call?.refuse(invitation, completion: nil)
                }
                self?.dismiss(animated: true, completion: nil)
            }

        } onError: {[weak self] (error) in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)
    }

}


extension VideoChatViewController {

    /// 接听
    @IBAction func answerEvent(){

        if let remoteInvitation = remoteInvitation  {
            Beehive.call?.accept(remoteInvitation, completion: { (code) in
                self.enableSDK()
            })
        }

    }


    
    /// 拒绝
    @IBAction func decline(){

        guard isConnected == false else {

            let provider:MoyaProvider<Api> = MoyaProvider()

            provider.rx.request(.end(id: input.channel)).subscribe { (response) in

                self.dismiss(animated: true, completion: nil)
            } onError: { (error) in
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: bag)


            return
        }

        let provider:MoyaProvider<Api> = MoyaProvider()

        provider.rx.request(.hangUp(id: input.channel)).subscribe {[weak self] (response) in

            if self?.input.isSender ?? false {

                if let invitation = self?.invitation  {
                    Beehive.call?.cancel(invitation, completion: nil)
                }
                self?.dismiss(animated: true, completion: nil)
            }else{
                if let invitation = self?.remoteInvitation  {
                    Beehive.call?.refuse(invitation, completion: nil)
                }
                self?.dismiss(animated: true, completion: nil)
            }

        } onError: {[weak self] (error) in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)

    }

}


extension VideoChatViewController : AgoraRtcEngineDelegate {

    // Swift
    // 监听 firstRemoteVideoDecodedOfUid 回调。
    // SDK 接收到第一帧远端视频并成功解码时，会触发该回调。
    // 可以在该回调中调用 setupRemoteVideo 方法设置远端视图。
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteVideo
        videoCanvas.renderMode = .hidden
        // 设置远端视图。
        rtc.setupRemoteVideo(videoCanvas)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {

        dismiss(animated: true, completion: nil)
    }

}


extension VideoChatViewController {

    struct Input {

        let token:String
        let uid:String
        let nickname:String
        let avatar:String
        let channel:String
        /// 是否是发送者
        let isSender:Bool
    }
}

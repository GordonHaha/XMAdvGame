//
//  RootViewController.swift
//  XMRun
//
//  Created by Gordon on 16/8/6.
//  Copyright © 2016年 Gordon. All rights reserved.
//

import UIKit
import SpriteKit

class RootViewController: UIViewController {
    
    private var menuView: MenuView?
    private var gameView: GameView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuView = MenuView(frame: self.view.bounds)
        self.menuView!.backgroundColor = UIColor.white
        self.menuView!.startButton!.addTarget(self, action: #selector(clickedStartButton(button:)), for: .touchUpInside)
        self.menuView!.aboutInfoButton!.addTarget(self, action:#selector(clickedAboutInfoButton(button:)), for: .touchUpInside)
        self.view.addSubview(self.menuView!)
        
        self.gameView = GameView(frame: self.view.bounds, menuView: self.menuView!)
        self.gameView!.backgroundColor = UIColor.white
        self.gameView!.removeFromSuperview()
        self.view.insertSubview(self.gameView!, belowSubview: self.menuView!)
    }
    
    @objc func clickedStartButton(button: UIButton) {
        self.gameView!.startGame()
        UIView.transition(from: self.menuView!, to: self.gameView!, duration: 0.5, options: .transitionFlipFromRight) { (true) in
        }
    }
    
    @objc func clickedAboutInfoButton(button: UIButton) {
        let alertView: UIAlertView = UIAlertView.init(title: "关于游戏", message: "本游戏内音、图等资源皆来源于网络，仅供学习，交流使用。版权归原作者所有。对游戏有任何反馈意见可邮件至gordonhaha@qq.com。", delegate: nil, cancelButtonTitle: "谢谢关注！")
        alertView.show()
    }
}

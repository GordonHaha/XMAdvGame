//
//  MenuView.swift
//  XMRun
//
//  Created by Gordon on 16/8/6.
//  Copyright © 2016年 Gordon. All rights reserved.
//

import UIKit

let kScreenSize = UIScreen.main.bounds

class MenuView: UIView {
    
    var startButton: UIButton?
    var aboutInfoButton: UIButton?
    
    private var titleImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleImageView = UIImageView(frame: CGRect(x: 0, y: kScreenSize.midY - 170, width: 280, height: 90))
        self.titleImageView!.image = UIImage(named: "title")
        self.titleImageView!.center = CGPoint(x: self.center.x, y: self.titleImageView!.center.y)
        self.addSubview(self.titleImageView!)
        
        self.startButton = UIButton(frame: CGRect(x: 0, y: kScreenSize.midY + 30, width: 210, height: 60))
        self.startButton!.setBackgroundImage(UIImage(named: "startGame"), for: .normal)
        self.startButton!.center = CGPoint(x: self.center.x, y: self.startButton!.center.y)
        self.addSubview(self.startButton!)
        
        self.aboutInfoButton = UIButton(frame: CGRect(x: 0, y: self.startButton!.frame.origin.y + 100, width: 210, height: 60))
        self.aboutInfoButton!.setBackgroundImage(UIImage(named: "aboutGame"), for: .normal)
        self.aboutInfoButton!.center = CGPoint(x: self.center.x, y: self.aboutInfoButton!.center.y)
        self.addSubview(self.aboutInfoButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

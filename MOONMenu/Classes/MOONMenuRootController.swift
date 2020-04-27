//
//  MOONMenuRootController.swift
//  MOONMenus
//
//  Created by 月之暗面 on 2020/4/26.
//  Copyright © 2020 月之暗面. All rights reserved.
//

import UIKit

extension MOONMenu.RootController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(closeView)
        view.addSubview(basicMenu)
        
        basicMenu.bounds = CGRect(origin: .zero, size: MOONMenu.core.config.closeSize)
        basicMenu.center = MOONMenu.core.config.closeCenter
        
        basicMenu.bindEvent { (event) in
            switch event {
            case .updated(state: let state):
                switch state {
                case .isOpen:
                    self.closeView.isHidden = false
                case .isClose:
                    self.closeView.isHidden = true
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        closeView.frame = view.bounds
    }
    
}


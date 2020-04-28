//
//  DebugViewController.swift
//  MOONMenu_Example
//
//  Created by 月之暗面 on 2020/4/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {
    
    //MARK: Interface
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViewsForDebug(box: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Data
    
    private func loadRequestForDebug() {
        
    }
    
    //MARK: View
    
    private func loadNavigationsForDebug() {
        
    }
    
    private func loadViewsForDebug(box: UIView) {
        
        view.backgroundColor = .green
        
        loadConstraintsForDebug(box: box)
    }
    
    private func loadConstraintsForDebug(box: UIView) {
        
    }
    
    //MARK: Event
    
    //MARK: - SubClass
    
}


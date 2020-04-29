//
//  ExampleDebugs.swift
//  MOONMenu_Example
//
//  Created by 月之暗面 on 2020/4/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import MOONMenu

class ExampleDebugs: NSObject {
    static let core = ExampleDebugs()
    private override init() {}
    
    let networkLog = XMNetworkLogs()
    
    ///加个锁
    private var queue = DispatchQueue(label: "moonmenu.networklog.write")
    
    func appendNetworkLogs() {
        queue.sync {
            for index in 0..<10 {
                let request = XMNetworkLogs.Request()
                request.state = (index % 2 == 0) ? .send : .receive
                
                request.time = "20:23:11"
                request.baseUrl = "https://www.baidu.com/"
                request.path = "~/Libeary/Developer/Xcode/DerivedData"
                request.method = "POST"
                request.header = "Content-Type: application/json"
                request.body = "Size: 20, Current: 1"
                
                request.traceId = "poiuytrewq"
                request.code = "200"
                request.content = "result: {test}"
                request.error = "error..."
                
                networkLog.logs.append(request)
            }
        }
    }
    
    func loadDebugTools() {
        var options: [MOONMenu.Config.Option] = []
        
        let info = MOONMenu.Config.Option()
        info.title = "当前信息"
        info.action = {
        }
        
        let sub1 = MOONMenu.Config.Option()
        sub1.title = "subs"
        sub1.action = {
            let infoVC = XMAppInfoList.ViewController()
            MOONMenu.core.nav.pushViewController(infoVC, animated: true)
        }
        info.subOption.append(sub1)
        
        options.append(info)
        
        let logs = MOONMenu.Config.Option()
        logs.title = "请求日志"
        logs.action = {
            let logVC = XMNetworkLogs.ViewController()
            MOONMenu.core.nav.pushViewController(logVC, animated: true)
        }
        options.append(logs)
        
        MOONMenu.core.config.options = options
        
        MOONMenu.core.start()
        
    }
}

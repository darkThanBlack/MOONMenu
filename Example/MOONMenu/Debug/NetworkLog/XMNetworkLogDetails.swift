//
//  XMNetworkLogDetails.swift
//  MOONMenu_Example
//
//  Created by 月之暗面 on 2020/4/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class XMNetworkLogDetails {
    
    class ViewModel {
        
        struct HintCellInfo: XMDebugCellHintDataSource {
            var style: XMDebugCell.Hint.Style
            var title: String?
            var detail: String?
        }
        var bottomCells: [HintCellInfo] = []
        
        func canQueryBottomCellsInfo(index: Int) -> Bool {
            return index < bottomCells.count ? true : false
        }
        
        class CellInfo: XMAppInfoListCellDataSource {
            var title: String?
            var detail: String?
        }
        var cells: [CellInfo] = []
        
        func canQueryCellInfo(index: Int) -> Bool {
            return index < cells.count ? true : false
        }
        
        fileprivate var jsonString: String?
        
        func loadData(params: XMNetworkLogs.Request, complete: (() -> Void)?) {
            
            var tmpBottomCells: [HintCellInfo] = []
            let share = HintCellInfo(style: .share, title: "现在，您可以将信息以标准 JSON 字符串形式传输到其他设备。", detail: "每按一次按钮，就可能有一个无辜的开发死于 BUG")
            tmpBottomCells.append(share)
            bottomCells = tmpBottomCells
            
            guard let data = try? JSONEncoder().encode(params) else { return }
            guard let jsonString = String(data: data, encoding: .utf8) else { return }
            self.jsonString = jsonString
            
            var tmpCells: [CellInfo] = []
            
            let state = CellInfo()
            state.title = "state"
            state.detail = params.state.rawValue
            tmpCells.append(state)
            
            let time = CellInfo()
            time.title = "time"
            time.detail = params.time
            tmpCells.append(time)
            
            let baseUrl = CellInfo()
            baseUrl.title = "baseUrl"
            baseUrl.detail = params.baseUrl
            tmpCells.append(baseUrl)
            
            let path = CellInfo()
            path.title = "path"
            path.detail = params.path
            tmpCells.append(path)
            
            let method = CellInfo()
            method.title = "method"
            method.detail = params.method
            tmpCells.append(method)
            
            let header = CellInfo()
            header.title = "header"
            header.detail = params.header
            tmpCells.append(header)
            
            let body = CellInfo()
            body.title = "header"
            body.detail = params.body
            tmpCells.append(body)
            
            let traceId = CellInfo()
            traceId.title = "traceId"
            traceId.detail = params.traceId
            tmpCells.append(traceId)
            
            let code = CellInfo()
            code.title = "code"
            code.detail = params.code
            tmpCells.append(code)
            
            let content = CellInfo()
            content.title = "content"
            content.detail = params.content
            tmpCells.append(content)
            
            let error = CellInfo()
            error.title = "error"
            error.detail = params.error
            tmpCells.append(error)
            
            cells = tmpCells
            
            DispatchQueue.main.async {
                complete?()
            }
        }
    }
    
    @objc(XMNetworkLogDetailsViewController)
    class ViewController: UIViewController {
        
        //MARK: Interface
        
        private let viewInfo = ViewModel()
        
        func configView(params: XMNetworkLogs.Request) {
            viewInfo.loadData(params: params) {
                self.tableView.reloadData()
            }
        }
        
        //MARK: Life Cycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            loadViews(box: view)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            self.title = "请求详情"
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        private func loadViews(box: UIView) {
            box.addSubview(tableView)
            loadConstraints(box: box)
        }
        
        private func loadConstraints(box: UIView) {
            tableView.snp.makeConstraints { (make) in
                make.top.equalTo(box.snp.top).offset(0)
                make.left.equalTo(box.snp.left).offset(0)
                make.right.equalTo(box.snp.right).offset(-0)
                make.bottom.equalTo(box.snp.bottom).offset(-0)
            }
        }
        
        private lazy var tableView: UITableView = {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(XMAppInfoList.Cell.self, forCellReuseIdentifier: "XMAppInfoList.Cell")
            tableView.register(XMDebugCell.Hint.self, forCellReuseIdentifier: "XMDebugCell.Hint")
            return tableView
        }()
        
        
    }

}

extension XMNetworkLogDetails.ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do nth.
    }
}

extension XMNetworkLogDetails.ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewInfo.cells.count
        }
        return viewInfo.bottomCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "XMAppInfoList.Cell", for: indexPath) as? XMAppInfoList.Cell
            if viewInfo.canQueryCellInfo(index: indexPath.row) {
                cell?.configCell(dataSource: viewInfo.cells[indexPath.row])
            }
            return cell ?? UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "XMDebugCell.Hint", for: indexPath) as? XMDebugCell.Hint
        if viewInfo.canQueryBottomCellsInfo(index: indexPath.row) {
            cell?.bindCell(delegate: self)
            cell?.configCell(dataSource: viewInfo.bottomCells[indexPath.row])
        }
        return cell ?? UITableViewCell()
        
    }
}

extension XMNetworkLogDetails.ViewController: XMDebugCellHintDelegate {
    
    func xmdebugCellEvent(cell: XMDebugCell.Hint, style: XMDebugCell.Hint.Style) {
        switch style {
        case .share:
            if (viewInfo.jsonString != nil) {
                let activityVC = UIActivityViewController.init(activityItems: [viewInfo.jsonString ?? ""], applicationActivities: nil)
                //activityVC.excludedActivityTypes = [UIActivityTypeAssignToContact]
                self.present(activityVC, animated: true, completion: {
                    
                })
            } else {
                let alert = UIAlertController(title: "提示", message: "json 解析失败", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
}


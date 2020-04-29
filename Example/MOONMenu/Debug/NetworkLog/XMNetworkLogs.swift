//
//  XMDebugNetLogs.swift
//  MOONMenu_Example
//
//  Created by 月之暗面 on 2020/4/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

///XMNetworkLogsCell 数据源
protocol XMNetworkLogsCellDataSource {
    var state: XMNetworkLogs.Request.State { get }
    var title: String? { get }
    var detail: String? { get }
    var time: String? { get }
}

class XMNetworkLogs {
    
    class Request: Codable, XMNetworkLogsCellDataSource {
        var title: String? { return path }
        var detail: String? { return traceId ?? body ?? code }
        
        enum State: String, Codable {
            case send
            case receive
            case unknown
        }
        var state: State = .unknown
        
        var time: String?
        var baseUrl: String?
        var path: String?
        var method: String?
        var header: String?
        var body: String?
        
        var traceId: String?
        var code: String?
        var content: String?
        var error: String?
    }
    var logs: [Request] = []
    
    func canQueryCellInfo(index: Int) -> Bool {
        return index < logs.count ? true : false
    }
    
    @objc(XMNetworkLogsViewController)
    class ViewController: UIViewController {
        
        //MARK: Interface
        
        private var viewModel = ExampleDebugs.core.networkLog
        
        //MARK: Life Cycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            loadViews(box: view)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            self.title = "请求日志"
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            tableView.reloadData()
        }
        
        //MARK: View
        
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
            tableView.separatorStyle = .singleLine
            tableView.register(Cell.self, forCellReuseIdentifier: "XMNetworkLogs.Cell")
            return tableView
        }()
        
    }
    
    @objc(XMNetworkLogsCell)
    class Cell: UITableViewCell {
        
        //MARK: Interface
        
        func configCell(dataSource: XMNetworkLogsCellDataSource) {
            titleLabel.text = dataSource.title ?? "-"
            timeLabel.text = dataSource.time ?? "-"
            detailLabel.text = dataSource.detail ?? "-"
            
            hintView.configView(state: dataSource.state)
        }
        
        //MARK: Life Cycle
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            self.selectionStyle = .none
            
            loadViewsForCell(box: contentView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: View
        
        private func loadViewsForCell(box: UIView) {
            box.addSubview(titleLabel)
            box.addSubview(detailLabel)
            box.addSubview(timeLabel)
            box.addSubview(hintView)
            
            loadConstraintsForCell(box: box)
        }
        
        private func loadConstraintsForCell(box: UIView) {
            
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
            titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
            
            hintView.snp.makeConstraints { (make) in
                make.centerY.equalTo(box.snp.centerY)
                make.left.equalTo(box.snp.left).offset(8.0)
                make.width.equalTo(50.0)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(box.snp.top).offset(8.0)
                make.left.equalTo(hintView.snp.right).offset(8.0)
            }
            timeLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(titleLabel.snp.centerY)
                make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(8.0)
                make.right.equalTo(box.snp.right).offset(-8.0)
            }
            detailLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(2.0)
                make.left.equalTo(titleLabel.snp.left).offset(0)
                make.right.equalTo(box.snp.right).offset(-8.0)
                make.bottom.equalTo(box.snp.bottom).offset(-8.0)
            }
        }
        
        private lazy var titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
            titleLabel.textColor = .black
            titleLabel.text = " "
            titleLabel.numberOfLines = 0
            return titleLabel
        }()
        
        private lazy var detailLabel: UILabel = {
            let detailLabel = UILabel()
            detailLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            detailLabel.textColor = .gray
            detailLabel.text = " "
            detailLabel.numberOfLines = 2
            return detailLabel
        }()
        
        private lazy var timeLabel: UILabel = {
            let timeLabel = UILabel()
            timeLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            timeLabel.textColor = .gray
            timeLabel.text = " "
            timeLabel.textAlignment = .center
            return timeLabel
        }()
        
        
        private lazy var hintView: StateView = {
            let hintView = StateView()
            hintView.layer.borderColor = UIColor.gray.cgColor
            hintView.layer.borderWidth = 0.5
            return hintView
        }()
        
        class StateView: UIView {
            
            //MARK: Interface
            
            func configView(state: Request.State) {
                switch state {
                case .send:
                    icon.text = ">>>"
                    icon.textColor = .green
                    hint.textColor = .green
                    hint.text = "发送"
                case .receive:
                    icon.text = "<<<"
                    icon.textColor = .blue
                    hint.textColor = .blue
                    hint.text = "接收"
                case .unknown:
                    icon.text = "-"
                    icon.textColor = .red
                    hint.textColor = .red
                    hint.text = "未知"
                }
            }
            
            //MARK: Life Cycle
            
            override init(frame: CGRect) {
                super.init(frame: frame)
                
                loadViewsForState(box: self)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            //MARK: View
            
            private func loadViewsForState(box: UIView) {
                box.addSubview(icon)
                box.addSubview(hint)
                
                loadConstraintsForState(box: box)
            }
            
            private func loadConstraintsForState(box: UIView) {
                icon.snp.makeConstraints { (make) in
                    make.top.equalTo(box.snp.top).offset(0)
                    make.left.equalTo(box.snp.left).offset(0)
                    make.right.equalTo(box.snp.right).offset(-0)
                }
                hint.snp.makeConstraints { (make) in
                    make.top.equalTo(icon.snp.bottom).offset(0)
                    make.left.equalTo(box.snp.left).offset(0)
                    make.right.equalTo(box.snp.right).offset(-0)
                    make.bottom.equalTo(box.snp.bottom).offset(-4.0)
                }
            }
            
            private lazy var icon: UILabel = {
                let icon = UILabel()
                icon.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
                icon.text = " "
                icon.textAlignment = .center
                return icon
            }()
            
            private lazy var hint: UILabel = {
                let hint = UILabel()
                hint.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                hint.text = " "
                hint.textAlignment = .center
                return hint
            }()
            
        }
        
    }


}

extension XMNetworkLogs.ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.canQueryCellInfo(index: indexPath.row) {
            let detailVC = XMNetworkLogDetails.ViewController()
            detailVC.configView(params: viewModel.logs[indexPath.row])
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension XMNetworkLogs.ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XMNetworkLogs.Cell", for: indexPath) as? XMNetworkLogs.Cell
        if viewModel.canQueryCellInfo(index: indexPath.row) {
            cell?.configCell(dataSource: viewModel.logs[indexPath.row])
        }
        return cell ?? UITableViewCell()
    }
}

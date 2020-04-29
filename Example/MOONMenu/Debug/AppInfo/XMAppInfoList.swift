//
//  XMAppInfoList.swift
//  XMApp
//
//  Created by 徐一丁 on 2020/4/28.
//  Copyright © 2020 jiejing. All rights reserved.
//

import UIKit

protocol XMAppInfoListCellDataSource {
    var title: String? { get }
    var detail: String? { get }
}

class XMAppInfoList {
    
    class ViewModel {
        
        class CellInfo: XMAppInfoListCellDataSource {
            var title: String?
            var detail: String?
        }
        var cells: [CellInfo] = []
        
        func loadData(complete: (() -> Void)?) {
            
            var tmpCells: [CellInfo] = []
            
#if IsXM
            
            let hosts = CellInfo()
            hosts.title = "当前环境"
            let hostFilePath = NSHomeDirectory() + "/Documents/XMai.xm"
            hosts.detail = (try? String(contentsOfFile: hostFilePath)) ?? "未检测到"
            tmpCells.append(hosts)
            
            let vers = CellInfo()
            vers.title = "当前版本"
            vers.detail = UserSession.isNewSaas ? "V5.0" : "V4.0"
            tmpCells.append(vers)
            
#endif
            
            cells = tmpCells
            
            DispatchQueue.main.async {
                complete?()
            }
        }
    }
    
    ///应用当前信息(待重构为看板)
    @objc(XMAppInfoListViewController)
    class ViewController: UIViewController {
        
        private let viewInfo = ViewModel()
        
        //MARK: Life Cycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            loadViewsForXMAppInfoList(box: view)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            self.title = "应用信息"
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            viewInfo.loadData {
                self.tableView.reloadData()
            }
        }
        
        //MARK: View
        
        private func loadViewsForXMAppInfoList(box: UIView) {
            box.addSubview(tableView)
            tableView.snp.makeConstraints { (make) in
                make.top.equalTo(box.snp.top).offset(0)
                make.left.equalTo(box.snp.left).offset(0)
                make.right.equalTo(box.snp.right).offset(-0)
                make.bottom.equalTo(box.snp.bottom).offset(-0)
            }
        }
        
        private lazy var tableView: UITableView = {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.backgroundColor = .white
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(XMAppInfoList.Cell.self, forCellReuseIdentifier: "XMAppInfoList.Cell")
            return tableView
        }()
    }
    
    @objc(XMAppInfoListCell)
    class Cell: UITableViewCell {
        
        //MARK: Interface
        
        func configCell(dataSource: XMAppInfoListCellDataSource) {
            titleLabel.text = dataSource.title
            detailLabel.text = dataSource.detail
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
            box.addSubview(sepLine)
            box.addSubview(singleLine)
            
            loadConstraintsForCell(box: box)
        }
        
        private func loadConstraintsForCell(box: UIView) {
            titleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(box.snp.centerY)
                make.left.equalTo(box.snp.left).offset(0)
                make.width.equalTo(100.0)
            }
            detailLabel.snp.makeConstraints { (make) in
                make.top.equalTo(box.snp.top).offset(0)
                make.left.equalTo(titleLabel.snp.right).offset(0)
                make.right.equalTo(box.snp.right).offset(-16.0)
                make.bottom.equalTo(box.snp.bottom).offset(-0).priority(.low)
                make.height.greaterThanOrEqualTo(44.0)
            }
            singleLine.snp.makeConstraints { (make) in
                make.centerY.equalTo(box.snp.centerY)
                make.right.equalTo(detailLabel.snp.left).offset(-0)
                make.width.equalTo(0.5)
                make.height.equalTo(detailLabel.snp.height)
            }
            sepLine.snp.makeConstraints { (make) in
                make.left.equalTo(box.snp.left).offset(0)
                make.right.equalTo(box.snp.right).offset(-0)
                make.bottom.equalTo(box.snp.bottom).offset(-0)
                make.height.equalTo(0.5)
            }
        }
        
        private lazy var titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
            titleLabel.textColor = .black
            titleLabel.text = " "
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        private lazy var detailLabel: UILabel = {
            let detailLabel = UILabel()
            detailLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            detailLabel.textColor = .gray
            detailLabel.text = " "
            detailLabel.numberOfLines = 0
            detailLabel.textAlignment = .center
            return detailLabel
        }()
        
        private lazy var sepLine: UIView = {
            let sepLine = UIView()
            sepLine.backgroundColor = .lightGray
            return sepLine
        }()
        
        private lazy var singleLine: UIView = {
            let singleLine = UIView()
            singleLine.backgroundColor = .lightGray
            return singleLine
        }()
        
    }
    
}

extension XMAppInfoList.ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do nth.
    }
}

extension XMAppInfoList.ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewInfo.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XMAppInfoList.Cell", for: indexPath) as? XMAppInfoList.Cell
        cell?.configCell(dataSource: viewInfo.cells[indexPath.row])
        return cell ?? UITableViewCell()
    }
}


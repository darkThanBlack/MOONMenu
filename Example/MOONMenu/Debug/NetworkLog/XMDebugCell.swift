//
//  XMDebugCell.swift
//  MOONMenu_Example
//
//  Created by 月之暗面 on 2020/4/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

///HintCell 用户事件
protocol XMDebugCellHintDelegate: class {
    func xmdebugCellEvent(cell: XMDebugCell.Hint, style: XMDebugCell.Hint.Style)
}

///HintCell 数据源
protocol XMDebugCellHintDataSource {
    var style: XMDebugCell.Hint.Style { get }
    var title: String? { get }
    var detail: String? { get }
}

class XMDebugCell {
    
    @objc(XMDebugCellHint)
    class Hint: UITableViewCell {
        
        //MARK: Interface
        
        enum Style {
            case share
        }
        private var style: Style = .share
        
        private weak var delegate: XMDebugCellHintDelegate?
        func bindCell(delegate: XMDebugCellHintDelegate) {
            self.delegate = delegate
        }
        
        func configCell(dataSource: XMDebugCellHintDataSource) {
            self.style = dataSource.style
            
            titleLabel.text = dataSource.title
            detailLabel.text = dataSource.detail
            
            switch dataSource.style {
            case .share:
                textButton.layer.borderColor = UIColor.blue.cgColor
                textButton.layer.borderWidth = 1.0
                
                textButton.setTitle("分享", for: .normal)
                textButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
                textButton.setTitleColor(.blue, for: .normal)
                textButton.setTitleColor(UIColor.blue.withAlphaComponent(0.6), for: .highlighted)
            }
        }
        
        //MARK: Life Cycle
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            self.selectionStyle = .none
            
            loadViewsForHint(box: contentView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: View
        
        private func loadViewsForHint(box: UIView) {
            box.addSubview(titleLabel)
            box.addSubview(detailLabel)
            box.addSubview(textButton)
            box.addSubview(singleLine)
            
            loadConstraintsForHint(box: box)
        }
        
        private func loadConstraintsForHint(box: UIView) {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(box.snp.top).offset(16.0)
                make.left.equalTo(box.snp.left).offset(16.0)
                make.right.equalTo(box.snp.right).offset(-100.0)
                
                make.height.greaterThanOrEqualTo(40.0)
            }
            detailLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
                make.left.equalTo(box.snp.left).offset(16.0)
                make.right.equalTo(box.snp.right).offset(-100.0)
                make.bottom.equalTo(box.snp.bottom).offset(-16.0)
            }
            textButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(box.snp.centerY)
                make.right.equalTo(box.snp.right).offset(-16.0)
                make.width.equalTo(60.0)
                make.height.equalTo(40.0)
            }
            singleLine.snp.makeConstraints { (make) in
                make.left.equalTo(box.snp.left).offset(0)
                make.right.equalTo(box.snp.right).offset(-0)
                make.bottom.equalTo(box.snp.bottom).offset(-0)
                make.height.equalTo(0.5)
            }
        }
        
        private lazy var titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
            titleLabel.textColor = .darkGray
            titleLabel.text = " "
            titleLabel.numberOfLines = 0
            return titleLabel
        }()
        
        private lazy var detailLabel: UILabel = {
            let detailLabel = UILabel()
            detailLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
            detailLabel.textColor = .lightGray
            detailLabel.text = " "
            detailLabel.numberOfLines = 0
            return detailLabel
        }()

        
        private lazy var textButton: UIButton = {
            let textButton = UIButton(type: .custom)
            textButton.layer.cornerRadius = 5.0
            textButton.layer.masksToBounds = true
            textButton.addTarget(self, action: #selector(textButtonEvent), for: .touchUpInside)
            return textButton
        }()
        
        private lazy var singleLine: UIView = {
            let singleLine = UIView()
            singleLine.backgroundColor = .lightGray
            return singleLine
        }()
        
        //MARK: Event
        
        @objc private func textButtonEvent() {
            self.delegate?.xmdebugCellEvent(cell: self, style: self.style)
        }
        
    }


}

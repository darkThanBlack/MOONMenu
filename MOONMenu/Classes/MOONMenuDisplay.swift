//
//  MOONMenuDisplay.swift
//  MOONMenus
//
//  Created by 月之暗面 on 2020/4/26.
//  Copyright © 2020 月之暗面. All rights reserved.
//

import UIKit

extension MOONMenu.Display {
    
    func configView(options: [MOONMenu.Config.Option], backAction: (() -> Void)?) {
        for item in items {
            item.removeFromSuperview()
        }
        items.removeAll()
        
        back.isHidden = backAction == nil ? true : false
        back.bindItem {
            backAction?()
        }
        
        var currentOptions: [MOONMenu.Config.Option] = []
        var moreOptions: [MOONMenu.Config.Option] = []
        
        if options.count <= 7 {
            currentOptions = options
            more.isHidden = true
        } else {
            currentOptions = Array(options.prefix(7))
            moreOptions = Array(options.suffix(from: 7))
            more.isHidden = false
            more.bindItem {
                self.openSubMenu(options: moreOptions)
            }
        }
        
        for option in currentOptions {
            let item = MOONMenu.Item(style: .item(title: option.title))
            item.configItem(skin: option.skin)
            item.bindItem {
                option.action?()
                
                if option.subOption.count > 0 {
                    self.openSubMenu(options: option.subOption)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: MOONMenuHelper.kMOONMenuCloseKey), object: nil, userInfo: nil)
                }
            }
            items.append(item)
        }
        
        for item in items {
            if MOONMenu.core.config.debuging == true {
                item.layer.borderWidth = 0.5
                item.layer.borderColor = UIColor.black.cgColor
            }
            self.addSubview(item)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func openSubMenu(options: [MOONMenu.Config.Option]) {
        let subDisplay = MOONMenu.Display()
        subDisplay.backgroundColor = .white
        self.addSubview(subDisplay)
        subDisplay.frame = self.bounds
        subDisplay.configView(options: options) {
            subDisplay.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let h_gap: CGFloat = 15.0
        let v_gap: CGFloat = 15.0
        let itemSize = CGSize(width: 80.0, height: 80.0)
        let p0 = CGPoint(x: h_gap + (h_gap + itemSize.width) * 0, y: v_gap + (v_gap + itemSize.height) * 0)
        let p1 = CGPoint(x: h_gap + (h_gap + itemSize.width) * 1, y: p0.y)
        let p2 = CGPoint(x: h_gap + (h_gap + itemSize.width) * 2, y: p0.y)
        let p3 = CGPoint(x: p0.x, y: v_gap + (v_gap + itemSize.height) * 1)
        let p4 = CGPoint(x: p1.x, y: p3.y)
        let p5 = CGPoint(x: p2.x, y: p3.y)
        let p6 = CGPoint(x: p0.x, y: v_gap + (v_gap + itemSize.height) * 2)
        let p7 = CGPoint(x: p1.x, y: p6.y)
        let p8 = CGPoint(x: p2.x, y: p6.y)
        
        back.frame = CGRect(origin: p4, size: itemSize)
        more.frame = CGRect(origin: p8, size: itemSize)
        
        for (index, item) in items.enumerated() {
            switch items.count {
            case 1:
                item.frame = CGRect(origin: p1, size: itemSize)
            case 2:
                switch index {
                case 0:
                    item.frame = CGRect(origin: p3, size: itemSize)
                case 1:
                    item.frame = CGRect(origin: p5, size: itemSize)
                default:
                    break
                }
            case 3:
                switch index {
                case 0:
                    item.frame = CGRect(origin: p1, size: itemSize)
                case 1:
                    item.frame = CGRect(origin: p3, size: itemSize)
                case 2:
                    item.frame = CGRect(origin: p5, size: itemSize)
                default:
                    break
                }
            case 4:
                switch index {
                case 0:
                    item.frame = CGRect(origin: p0, size: itemSize)
                case 1:
                    item.frame = CGRect(origin: p2, size: itemSize)
                case 2:
                    item.frame = CGRect(origin: p6, size: itemSize)
                case 3:
                    item.frame = CGRect(origin: p8, size: itemSize)
                default:
                    break
                }
            case 5:
                switch index {
                case 0:
                    item.frame = CGRect(origin: p1, size: itemSize)
                case 1:
                    item.frame = CGRect(origin: p3, size: itemSize)
                case 2:
                    item.frame = CGRect(origin: p5, size: itemSize)
                case 3:
                    item.frame = CGRect(origin: p6, size: itemSize)
                case 4:
                    item.frame = CGRect(origin: p8, size: itemSize)
                default:
                    break
                }
            case 6:
                switch index {
                case 0:
                    item.frame = CGRect(origin: p0, size: itemSize)
                case 1:
                    item.frame = CGRect(origin: p2, size: itemSize)
                case 2:
                    item.frame = CGRect(origin: p3, size: itemSize)
                case 3:
                    item.frame = CGRect(origin: p5, size: itemSize)
                case 4:
                    item.frame = CGRect(origin: p6, size: itemSize)
                case 5:
                    item.frame = CGRect(origin: p8, size: itemSize)
                default:
                    break
                }
            case 7:
                switch index {
                case 0:
                    item.frame = CGRect(origin: p0, size: itemSize)
                case 1:
                    item.frame = CGRect(origin: p1, size: itemSize)
                case 2:
                    item.frame = CGRect(origin: p2, size: itemSize)
                case 3:
                    item.frame = CGRect(origin: p3, size: itemSize)
                case 4:
                    item.frame = CGRect(origin: p5, size: itemSize)
                case 5:
                    item.frame = CGRect(origin: p6, size: itemSize)
                case 6:
                    item.frame = CGRect(origin: p7, size: itemSize)
                default:
                    break
                }
            default:
                break
            }
        }
        
    }

}

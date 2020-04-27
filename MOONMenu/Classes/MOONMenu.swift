//
//  MOONMenu.swift
//  MOONMenus
//
//  Created by 月之暗面 on 2020/4/23.
//  Copyright © 2020 月之暗面. All rights reserved.
//

import Foundation
import UIKit

///菜单
public class MOONMenu: NSObject {
    ///核心单例
    public static let core = MOONMenu()
    ///核心配置项
    public let config: Config
    ///持久化标识
    private let key = "kMOONMenuConfigKey"
    ///起飞
    public func start() {
        window.isHidden = false
    }
    private override init() {
        let jsonString = UserDefaults.standard.string(forKey: key)
        guard let data = jsonString?.data(using: .utf8) else {
            config = Config()
            return
        }
        config = (try? JSONDecoder().decode(Config.self, from: data)) ?? Config()
    }
    
    func saveConfigs() {
        guard let data = try? JSONEncoder().encode(self.config) else { return }
        guard let jsonString = String(data: data, encoding: .utf8) else { return }
        if config.debuging {
            print("MOON__Log__config_save \(jsonString)")
        }
        UserDefaults.standard.set(jsonString, forKey: self.key)
        UserDefaults.standard.synchronize()
    }
    
    private lazy var window: Window = {
        let window = Window(frame: UIScreen.main.bounds)
        window.windowLevel = .alert
        window.rootViewController = UINavigationController.init(rootViewController: self.rootVC)
        window.noResponseView = self.rootVC.view
        return window
    }()
    
    lazy var rootVC: RootController = {
        let rootVC = RootController()
        return rootVC
    }()
    
    lazy var nav: UINavigationController = {
        return UINavigationController(rootViewController: self.rootVC)
    }()
    
    @objc(MOONMenuConfig)
    public class Config: NSObject, Codable {
        ///调试输出
        public var debuging = false
        
        public enum AbsorbMode: String, Codable {
            case system
            case edge
            case none
        }
        ///吸附模式
        public var absorb = AbsorbMode.system
        
        public enum Skin: String, Codable {
            case moon_shadow
        }
        ///皮肤
        public var skin: Skin = .moon_shadow
        
        @objc(MOONMenuConfigOption)
        public class Option: NSObject, Codable {
            
            public  var title: String?
            
            public  var action: (() -> Void)?
            
            public  var subOption: [Option] = []
            
            public  var skin: String?
            
            public func encode(to encoder: Encoder) throws {}
            required public init(from decoder: Decoder) throws {}
            public required override init() {}
        }
        ///选项
        public var options: [Option] = []
        
        enum MenuState: String, Codable {
            case isOpen
            case isClose
        }
        ///状态:开启/关闭
        var state = MenuState.isClose
        
        var openSize = CGSize(width: 300.0, height: 300.0)
        
        var closeSize = CGSize(width: 65.0, height: 65.0)
        
        var openCenter = CGPoint(x: UIScreen.main.bounds.width / 2.0, y: UIScreen.main.bounds.height * 0.33)
        
        var closeCenter: CGPoint = CGPoint(x: 200, y: 200)
    }
    
    @objc(MOONMenuWindow)
    private class Window: UIWindow {
        
        var noResponseView: UIView? = nil
        
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let view = super.hitTest(point, with: event)
            return (view?.isEqual(noResponseView) ?? false) ? nil : view
        }
    }
    
    @objc(MOONMenuRootController)
    class RootController: UIViewController {
        ///空白处关闭
        lazy var closeView: UIView = {
            let closeView = UIView.init()
            closeView.backgroundColor = .clear
            closeView.isHidden = true
            
            closeView.isUserInteractionEnabled = true
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(closeMunuEvent))
            singleTap.numberOfTapsRequired = 1
            singleTap.numberOfTouchesRequired = 1
            closeView.addGestureRecognizer(singleTap)
            
            return closeView
        }()
        
        @objc func closeMunuEvent() {
            basicMenu.updateMunuState()
        }
        
        ///根菜单
        lazy var basicMenu: Basic = {
            let basicMenu = Basic()
            basicMenu.backgroundColor = .clear
            basicMenu.layer.cornerRadius = 15.0
            basicMenu.layer.masksToBounds = true
            return basicMenu
        }()
    }
    
    @objc(MOONMenuBasic)
    class Basic: UIView {
        ///配置项
        let config = MOONMenu.core.config
        ///是否正在开启/关闭
        var isUpdating = false
        ///记录手势起始位置
        var beginPoint = CGPoint.zero
        
        enum Event {
            case updated(state: Config.MenuState)
        }
        var action: ((Event) -> Void)?
        func bindEvent(action: ((Event) -> Void)?) {
            self.action = action
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(icon)
            addSubview(visualView)
            addSubview(display)
            
            display.configView(options: config.options, backAction: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            icon.frame = bounds
            visualView.frame = bounds
            display.frame = bounds
        }
        ///关闭状态展示
        lazy var icon: UIImageView = {
            let icon = UIImageView()
            icon.image = MOONMenuHelper.queryImage(named: "moonShadow")
            icon.isUserInteractionEnabled = true
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(openMenuEvent))
            singleTap.numberOfTapsRequired = 1
            singleTap.numberOfTouchesRequired = 1
            icon.addGestureRecognizer(singleTap)
            
            return icon
        }()
        
        @objc func openMenuEvent() {
            updateMunuState()
        }
        
        ///透明效果
        lazy var visualView: UIVisualEffectView = {
            var effect: UIVisualEffect
            if #available(iOS 13.0, *) {
                effect = UIBlurEffect(style: .systemMaterial)
            } else {
                effect = UIBlurEffect(style: .extraLight)
            }
            let visualView = UIVisualEffectView(effect: effect)
            visualView.alpha = 0.0
            return visualView
        }()
        ///子菜单
        lazy var display: Display = {
            let display = Display()
            display.alpha = 0.0
            return display
        }()
        
    }
    
    @objc(MOONMenuDisplay)
    class Display: UIView {
        
        var items: [Item] = []
        let more = Item(style: .more)
        let back = Item(style: .back)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            more.configItem(skin: "moonmenu_dark_more")
            back.configItem(skin: "moonmenu_dark_back")
            
            self.addSubview(more)
            self.addSubview(back)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    @objc(MOONMenuItem)
    class Item: UIView {
        enum Style {
            case item(title: String?)
            case more
            case back
        }
        private var style: Style = .item(title: nil)
        
        private var action: (() -> Void)?
        func bindItem(action: (() -> Void)?) {
            self.action = action
        }
        
        func configItem(skin: String?) {
            let imageName: String = skin ?? "moonmenu_item_dark_\(arc4random_uniform(19))"
            picture.image = MOONMenuHelper.queryImage(named: imageName)
        }
        
        init(style: Style) {
            super.init(frame: .zero)
            
            self.style = style
            switch self.style {
            case .item(let title):
                titleLabel.text = title
            case .more:
                titleLabel.text = "更多"
            case .back:
                titleLabel.text = "返回"
            }
            
            if MOONMenu.core.config.debuging {
                picture.layer.borderWidth = 0.5
                picture.layer.borderColor = UIColor.blue.cgColor
                
                titleLabel.layer.borderWidth = 0.5
                titleLabel.layer.borderColor = UIColor.green.cgColor
            }
            
            addSubview(picture)
            addSubview(titleLabel)
            
            self.isUserInteractionEnabled = true
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(itemEvent(gesture:)))
            singleTap.numberOfTapsRequired = 1
            singleTap.numberOfTouchesRequired = 1
            self.addGestureRecognizer(singleTap)
            
        }
        
        @objc private func itemEvent(gesture: UITapGestureRecognizer) {
            self.action?()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            picture.frame = CGRect(x: 16.0, y: 8.0, width: self.bounds.width - 32.0, height: self.bounds.width - 32.0)
            
            titleLabel.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: picture.frame.midX, y: picture.frame.maxY + titleLabel.bounds.maxY / 2.0 + 4.0)
        }
        
        private lazy var picture: UIImageView = {
            let picture = UIImageView()
            picture.contentMode = .scaleAspectFit
            return picture
        }()
        
        private lazy var titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            titleLabel.textColor = .black
            titleLabel.text = " "
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
    }
}

//
//  MOONMenuBasic.swift
//  MOONMenus
//
//  Created by 月之暗面 on 2020/4/26.
//  Copyright © 2020 月之暗面. All rights reserved.
//

import UIKit

extension MOONMenu.Basic {
    
    //MARK: Interface
    
    func updateMunuState() {
        isUpdating = true
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            switch self.config.state {
            case .isOpen:
                self.bounds = CGRect(origin: .zero, size: self.config.closeSize)
                self.center = self.config.closeCenter
                
                self.icon.alpha = 1.0
                self.visualView.alpha = 0.0
                self.display.alpha = 0.0
            case .isClose:
                self.bounds = CGRect(origin: .zero, size: self.config.openSize)
                self.center = self.config.openCenter
                
                self.icon.alpha = 0.0
                self.visualView.alpha = 1.0
                self.display.alpha = 1.0
            }
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }) { (finished) in
            switch self.config.state {
            case .isOpen:
                self.config.state = .isClose
            case .isClose:
                self.config.state = .isOpen
            }
            self.isUpdating = false
            
            self.action?(.updated(state: self.config.state))
            
            MOONMenu.core.saveConfigs()
            
            //TODO: Delay fade
        }
    }
    
    //MARK: Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beginPoint = touches.first?.previousLocation(in: self) ?? CGPoint.zero
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch config.state {
        case .isOpen:
            break
        case .isClose:
            let newPoint = touches.first?.location(in: self) ?? CGPoint.zero
            
            self.center.x += newPoint.x - beginPoint.x
            self.center.y += newPoint.y - beginPoint.y
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesHandle()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.tapCount == 1 {
            if touches.first?.view == icon {
                print("MOON__Log  got icon toches...")
            }
        }
        touchesHandle()
    }
    
    //MARK: Private
    
    //TODO: Filter tap and pan gesture
    private func touchesHandle() {
        if !isUpdating {
            switch config.state {
            case .isOpen:
                break
            case .isClose:
                let result = countingAdaptPosition()
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.center = result
                }) { (finished) in
                    self.config.closeCenter = self.center
                }
            }
        }
    }
    
    ///计算最终位置
    private func countingAdaptPosition() -> CGPoint {
        var result = CGRect(origin: CGPoint(x: self.center.x - self.bounds.width / 2.0, y: self.center.y - self.bounds.height / 2.0), size: self.bounds.size)
        let barrier = UIScreen.main.bounds
        switch config.absorb {
        case .system:
            result = makeFrameAbsorb(frame: result, barrier: barrier)
            break
        case .edge:
            result = makeFrameEdgeAbsorb(frame: result, barrier: barrier)
            break
        case .none:
            result = makeFrameInBarrier(frame: result, barrier: barrier)
            break
        }
        
        return CGPoint(x: result.midX, y: result.midY)
    }
    
    ///保证在屏幕内
    private func makeFrameInBarrier(frame: CGRect, barrier: CGRect) -> CGRect {
        var result = frame
        
        let maxWidth = barrier.width - result.width
        let maxHeight = barrier.height - result.height
        
        result.origin.x = (result.origin.x < 0) ? 0 : result.origin.x
        result.origin.y = (result.origin.y < 0) ? 0 : result.origin.y
        
        result.origin.x = (result.origin.x > maxWidth) ? maxWidth : result.origin.x
        result.origin.y = (result.origin.y > maxHeight) ? maxHeight : result.origin.y
        
        return result
    }
    ///直接吸附
    private func makeFrameAbsorb(frame: CGRect, barrier: CGRect) -> CGRect {
        var result = makeFrameInBarrier(frame: frame, barrier: barrier)
        
        let maxX = barrier.width - result.width
        let maxY = barrier.height - result.height
        
        let dT = result.midY
        let dL = result.midX
        let dB = barrier.height - dT
        let dR = barrier.width - dL
        let dMin = [dT, dL, dB, dR].sorted().first  //决定向哪个方向吸附
        
        if (dMin == dT) {
            result = CGRect(origin: CGPoint(x: result.origin.x, y: 0), size: result.size)
        } else if (dMin == dB) {
            result = CGRect(origin: CGPoint(x: result.origin.x, y: maxY), size: result.size)
        } else if (dMin == dL) {
            result = CGRect(origin: CGPoint(x: 0, y: result.origin.y), size: result.size)
        } else if (dMin == dR) {
            result = CGRect(origin: CGPoint(x: maxX, y: result.origin.y), size: result.size)
        }
        
        return result
    }
    ///贴近边界才吸附
    private func makeFrameEdgeAbsorb(frame: CGRect, barrier: CGRect) -> CGRect {
        let absorbEdge = max(frame.width, frame.height) / 2.0
        let newBarrier = CGRect(origin: .zero,
                                size: CGSize(width: barrier.width - absorbEdge,
                                             height: barrier.height - absorbEdge))
        if (newBarrier.contains(frame)) {
            return frame
        } else {
            return makeFrameAbsorb(frame: frame, barrier: newBarrier)
        }
    }
    
    
}

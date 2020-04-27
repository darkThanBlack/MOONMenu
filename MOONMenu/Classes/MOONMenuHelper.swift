//
//  MOONMenuHelper.swift
//  MOONMenus
//
//  Created by 月之暗面 on 2020/4/27.
//  Copyright © 2020 月之暗面. All rights reserved.
//

import UIKit

class MOONMenuHelper {
    
    static func queryImage(named: String) -> UIImage? {
        let baseBundle = Bundle(for: MOONMenuHelper.self)
        guard let url = baseBundle.url(forResource: "MOONMenuSkin", withExtension: "bundle"), let bundle = Bundle(url: url) else {
            return UIImage(named: named)
        }
        return UIImage(named: named, in: bundle, compatibleWith: nil) ?? UIImage(named: named)
    }
    
}

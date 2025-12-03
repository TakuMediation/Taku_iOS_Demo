//
//  WildClickButton.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit

class WildClickButton: UIButton {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = self.bounds
        // 扩大原热区直径至26，可以暴露个接口，用来设置需要扩大的半径。
        let widthDelta = max(26, 0)
        let heightDelta = max(26, 0)
        bounds = bounds.insetBy(dx: -0.5 * CGFloat(widthDelta), dy: -0.5 * CGFloat(heightDelta))
        return bounds.contains(point)
    }
}

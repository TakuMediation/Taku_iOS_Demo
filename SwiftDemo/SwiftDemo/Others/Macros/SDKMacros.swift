//
//  SDKMacros.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit
import Foundation

// MARK: - 日志相关
func DemoLogAccess(_ l: Int) {
    let isOpenLog = l == 0 ? false : true
    UserDefaults.standard.set(isOpenLog, forKey: "iOSDemoLogSw")
}

func ATDemoLog(_ format: String, _ args: CVarArg...) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Beijing")
    dateFormatter.dateFormat = "HH:mm:ss.SSSSSSZ"
    let str = dateFormatter.string(from: Date())
    
    if UserDefaults.standard.bool(forKey: "iOSDemoLogSw") {
        let message = String(format: format, arguments: args)
        let fileName = (#file as NSString).lastPathComponent
        print("[iOSDemo]--TIME：\(str)[FILE：\(fileName)--LINE：\(#line)]FUNCTION：\(#function)\n\(message)\n")
    }
}

// MARK: - UI相关
func kImg(_ name: String) -> UIImage? {
    return UIImage(named: name)
}

var isiPAD: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

// size
let kUIRefereWidth: CGFloat = isiPAD ? 804.0 : 804.0  // 手机参考宽度
let kUIRefereHeight: CGFloat = isiPAD ? 1748.0 : 1748.0  // 手机参考高度

var kNavigationBarHeight: CGFloat {
    let orientation = UIApplication.shared.statusBarOrientation
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    if orientation == .portrait || orientation == .portraitUpsideDown {
        return statusBarHeight + 44
    } else {
        return statusBarHeight - 4
    }
}

var kOrientationScreenWidth: CGFloat {
    let bounds = UIScreen.main.bounds
    return bounds.width > bounds.height ? bounds.height : bounds.width
}

var kOrientationScreenHeight: CGFloat {
    let bounds = UIScreen.main.bounds
    return bounds.width > bounds.height ? bounds.width : bounds.height
}

//  (设计图的值/设计图屏幕尺寸) * 当前屏幕尺寸 = 返回的值
func kAdaptX(_ x: CGFloat, _ padx: CGFloat) -> CGFloat {
    return ((isiPAD ? padx : x) / kUIRefereWidth) * kOrientationScreenWidth
}

func kAdaptY(_ y: CGFloat, _ pady: CGFloat) -> CGFloat {
    return ((isiPAD ? pady : y) / kUIRefereHeight) * kOrientationScreenHeight
}

func kAdaptW(_ w: CGFloat, _ padw: CGFloat) -> CGFloat {
    return ((isiPAD ? padw : w) / kUIRefereWidth) * kOrientationScreenWidth
}

func kAdaptH(_ h: CGFloat, _ padh: CGFloat) -> CGFloat {
    return ((isiPAD ? padh : h) / kUIRefereHeight) * kOrientationScreenHeight
}

func kAdaptFont(_ s: CGFloat) -> CGFloat {
    return (s / kUIRefereWidth) * kOrientationScreenWidth
}

let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

// colors
func kHexColorAlpha(_ rgbValue: UInt32, _ alpha: CGFloat) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0xFF) / 255.0,
        alpha: alpha
    )
}

func kHexColor(_ rgbValue: UInt32) -> UIColor {
    return kHexColorAlpha(rgbValue, 1.0)
}

func kRGBColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

func kRGBColorAlpha(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
}

func kRGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

let kScreenScaleString = ""

var isHaveSafeArea: Bool {
    if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return false }
        return window.safeAreaInsets.bottom > 0
    }
    return false
}

var TopSafeAreaHeight: CGFloat {
    if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.top
    }
    return 0
}

var BottomSafeAreaHeight: CGFloat {
    if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    }
    return 0
}

var LeftSafeAreaWidth: CGFloat {
    if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.left
    }
    return 0
}

var RightSafeAreaWidth: CGFloat {
    if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.right
    }
    return 0
}

var kStatusBarHeight: CGFloat {
    if #available(iOS 13.0, *) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return windowScene.statusBarManager?.statusBarFrame.size.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.size.height
    }
}

// MARK: - Tools
let kUserDefaults = UserDefaults.standard

func kStringIsEmpty(_ str: String?) -> Bool {
    guard let str = str else { return true }
    return str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}

func kTrimStrSpace(_ str: String) -> String {
    return str.replacingOccurrences(of: " ", with: "")
}

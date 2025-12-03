//
//  LocalizationManager.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import Foundation

// 全局函数，等效于OC中的宏定义
func kLocalizeStr(_ key: String) -> String {
    return LocalizationManager.shared.getString(byKey: key)
}

class LocalizationManager: NSObject {
    
    static let shared = LocalizationManager()
    
    private var info: [String: Any]?
    
    private override init() {
        super.init()
    }
    
    func getString(byKey key: String) -> String {
        // 获取系统当前语言版本(中文zh-Hans,英文en)
        let languages = Locale.preferredLanguages
        guard let firstLanguage = languages.first else { return "" }
        
        var language = LocalizationManager.languageFormat(firstLanguage)
        if language != "zh-Hans" && language != "zh-Hant" && language != "ko" {
            language = "en"
        }
        
        if info == nil {
            guard let filePath = Bundle.main.path(forResource: "file", ofType: ""),
                  let data = NSData(contentsOfFile: filePath),
                  let dict = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [String: Any] else {
                return ""
            }
            self.info = dict
        }
        
        guard let info = self.info,
              let keyDict = info[key] as? [String: String],
              let result = keyDict[language] else {
            return ""
        }
        
        return result.isEmpty ? "" : result
    }
    
    /// 语言和语言对应的.lproj的文件夹前缀不一致时在这里做处理
    static func languageFormat(_ language: String) -> String {
        if language.contains("zh-Hans") {
            return "zh-Hans"
        } else if language.contains("zh-Hant") {
            return "zh-Hant"
        } else {
            // 字符串查找
            if language.contains("-") {
                // 除了中文以外的其他语言统一处理@"ru_RU" @"ko_KR"取前面一部分
                let components = language.components(separatedBy: "-")
                if components.count > 1 {
                    return components[0]
                }
            }
        }
        return language
    }
    
    static func getSystemLanguage() -> String {
        let appLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String]
        return appLanguages?.first ?? ""
    }
    
    static func userLang() -> String {
        var sysLang = getSystemLanguage()
        if sysLang.contains("Hans") {
            sysLang = "CN"
        } else if sysLang.contains("Hant") {
            sysLang = "TW"
        } else if sysLang.contains("ko") {
            sysLang = "KR"
        } else {
            sysLang = "EN"
        }
        return sysLang
    }
}

//
//  Theme.swift
//  Ping
//
//  Created by infuntis on 25/01/17.
//  Copyright © 2017 gala. All rights reserved.
//

import Foundation
import UIKit
let SelectedThemeKey = "SelectedTheme"

enum ThemeAnimal: Int{
    case koala = 0, crab
    
    static var count: Int { return ThemeAnimal.crab.hashValue + 1}
    
    
    var prefix: String{
        switch self {
        case .crab:
            return "crab"
        case .koala:
            return "koala"
        }
    }
    
    var string: String {
        return String(describing: self)
    }
}

struct ThemeManager {
    
    static func currentTheme() -> ThemeAnimal {
        UserDefaults.standard.value(forKeyPath: SelectedThemeKey)
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return ThemeAnimal(rawValue: storedTheme)!
        } else {
            return .koala
        }
    }
    
    static func applyTheme(_ theme: ThemeAnimal) {
        UserDefaults.standard.set(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
    }
}


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
    case koala = 0, crab, fox, parrot, unicorn, monkey, octopus, fish, duck
    
    static var count: Int { return ThemeAnimal.duck.hashValue + 1}
    
    
    var prefix: String{
        switch self {
        case .crab:
            return "crab"
        case .koala:
            return "koala"
        case .fox:
            return "fox"
        case .parrot:
            return "parrot"
        case .unicorn:
            return "unicorn"
        case .monkey:
            return "monkey"
        case .octopus:
            return "octopus"
        case .fish:
            return "fish"
        case .duck:
            return "duck"
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


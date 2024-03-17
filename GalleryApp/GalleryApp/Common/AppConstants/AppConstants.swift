import UIKit
enum AppColors {
    case background
    case activeButton
    case inactiveButton
    case descriptionBackground
    case descriptionTitleTextColor
    case headerColor
    case mainTextColor
    var color: UIColor {
        switch self {
            case .background:
                return UIColor(named: "backgroundColor") ?? .background
            case .activeButton:
                return UIColor(named: "activeButton") ?? .blue
            case .inactiveButton:
                return UIColor(named: "inactiveButton") ?? .white
            case .descriptionBackground:
                return UIColor(named: "descriptionBackground") ?? .white
            case .descriptionTitleTextColor:
                return UIColor(named: "descriptionTitleTextColor") ?? .black
            case .headerColor:
                return UIColor(named: "headerColor") ?? .black
            case .mainTextColor:
                return UIColor(named: "mainTextColor") ?? .black
        }
    }
}

enum UIConstants {
    
}

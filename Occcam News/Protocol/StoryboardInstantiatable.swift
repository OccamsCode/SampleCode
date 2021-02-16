//
//  StoryboardInstantiatable.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
import UIKit

public enum StoryboardInstantiateType {
    case initial
    case identifier(String)
}

public protocol StoryboardInstantiatable {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle { get }
    static var instantiateType: StoryboardInstantiateType { get }
}

public extension StoryboardInstantiatable where Self: NSObject {
    static var storyboardName: String {
        return "Main"
    }
    
    static var storyboardBundle: Bundle {
        return Bundle(for: self)
    }
    
    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: storyboardBundle)
    }
    
    static var instantiateType: StoryboardInstantiateType {
        return .identifier(className)
    }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        switch instantiateType {
        case .initial:
            return storyboard.instantiateInitialViewController() as! Self
        case .identifier(let identifier):
            return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        }
    }
}

/*
 TODO:
    1. Replace with StoryboardInstantiatable with IBInstantiatable
    2. Get it to work UITableViewCell & UICollectionViewCell
 */

public enum IBInstanceType {
    case nib
    case storyboardInitial
    case storyboardIdentifier(String)
}

public protocol IBInstantiatable {
    static var storyboardName: String { get }
    static var bundle: Bundle { get }
    static var nibName: String { get }
    static var instantiateType: IBInstanceType { get }
}

public extension IBInstantiatable where Self: NSObject {
    
    static var storyboardName: String {
        return "Main"
    }
    
    static var nibName: String {
        return className
    }
    
    static var bundle: Bundle {
        return Bundle(for: self)
    }
    
    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: bundle)
    }
    
    static var instantiateType: StoryboardInstantiateType {
        return .identifier(className)
    }
    
}

public extension IBInstantiatable where Self: UIViewController {
    
    static func instantiate() -> Self {
        
        switch instantiateType {
        case .nib:
            return Self.init(nibName: nibName, bundle: bundle)
        case .storyboardInitial:
            return storyboard.instantiateInitialViewController() as! Self
        case .storyboardIdentifier(let identifier):
            return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        }
        
    }
    
}

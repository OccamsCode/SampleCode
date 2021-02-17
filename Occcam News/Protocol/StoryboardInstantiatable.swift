//
//  StoryboardInstantiatable.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
import UIKit

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
    
    static var instantiateType: IBInstanceType {
        return .storyboardIdentifier(className)
    }
    
}

public extension IBInstantiatable where Self: UIViewController {
    
    static func instantiate() -> Self {
        
        switch instantiateType {
        case .nib:
            return Self.init(nibName: nibName, bundle: bundle)
        case .storyboardInitial:
            guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
                fatalError("Unable to cast initial ViewController to \(Self.className)")
            }
            return viewController
        case .storyboardIdentifier(let identifier):
            guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? Self else {
                fatalError("Unable to cast ViewController with ID \(identifier) to \(Self.className)")
            }
            return viewController
        }
        
    }
    
}

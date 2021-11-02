//
//  ViewControllerFactory.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/03/2021.
//

import UIKit
import Foundation
import SafariServices

protocol Previewable {}

extension UIViewController: Previewable {}

class ViewControllerFactory {
    
    class func preview(for article: Article) -> Previewable {
        return produce(safariControllerFrom: article)
    }
    
    // Produce a SFSafariViewController
    class func produce(safariControllerFrom article: Article) -> SFSafariViewController {
        return SFSafariViewController(url: article.url)
    }
    
    // Produce a generic ViewController which is IBInstantiatable
    class func produce<T: UIViewController>(_ viewController: T.Type) -> T where T: IBInstantiatable {
        return viewController.instantiate()
    }
}

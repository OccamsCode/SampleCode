//
//  ViewController.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .magenta
    }


}

extension ViewController: StoryboardInstantiatable {
    
    static var instantiateType: StoryboardInstantiateType {
        return .initial
    }
    
}

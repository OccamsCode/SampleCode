//
//  TableViewCellReuse.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/03/2021.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle = .main) {
        let className = cellType.className

        if bundle.path(forResource: className, ofType: "nib") != nil {
            let nib = UINib(nibName: className, bundle: bundle)
            register(nib, forCellReuseIdentifier: className)
        } else {
            register(T.self, forCellReuseIdentifier: className)
        }
    }

    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle = .main) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T else {
            fatalError("Cell with reuseIdentifier \(type.className) is not of type \(type.className)")
        }
        return cell
    }

}

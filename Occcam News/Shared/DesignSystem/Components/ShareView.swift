//
//  ActivityView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 16/11/2023.
//

import SwiftUI

protocol Shareable {
    func getPlaceholderItem() -> Any
    func itemForActivityType(activityType: UIActivity.ActivityType?) -> Any?
    func subjectForActivityType(activityType: UIActivity.ActivityType?) -> String
}

extension Shareable {
    func subjectForActivityType(activityType: UIActivity.ActivityType?) -> String {
        return String()
    }
}

struct ShareView: UIViewControllerRepresentable {

    var activityItems: [Any]
    var shareable: Shareable?
    var applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        controller.modalPresentationStyle = .automatic
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ShareView>) {}

    func makeCoordinator() -> ShareView.Coordinator {
        Coordinator(self.shareable)
    }

    class Coordinator: NSObject, UIActivityItemSource {

        private let shareable: Shareable?

        init(_ shareable: Shareable?) {
            self.shareable = shareable
            super.init()
        }

        func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            guard let share = self.shareable else { return "" }
            return share.getPlaceholderItem()
        }

        func activityViewController(_ activityViewController: UIActivityViewController,
                                    itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            guard let share = self.shareable else { return "" }
            return share.itemForActivityType(activityType: activityType)
        }

        func activityViewController(_ activityViewController: UIActivityViewController,
                                    subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
            guard let share = self.shareable else { return "" }
            return share.subjectForActivityType(activityType: activityType)
        }
    }
}

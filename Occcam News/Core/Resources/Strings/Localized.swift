//
//  Localized.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/02/2023.
//

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces

internal enum Localized {

    internal enum HomeViewModel {

        internal enum TabBarItem {
            internal static let text = Localized.tr("Localizable", "HomeViewModel.TabBarItem.Title")
        }
        internal enum NavigationItem {
            internal static let text = Localized.tr("Localizable", "HomeViewModel.NavigationItem.Title")
        }
        internal enum RefreshControl {
            internal static let text = Localized.tr("Localizable", "HomeViewModel.RefreshControl.Title")
        }
    }
}

extension Localized {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
      }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

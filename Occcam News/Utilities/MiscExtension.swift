import Foundation

// MARK: - Date Formatting
extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Formatter.iso8601withFractionalSeconds.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container,
                  debugDescription: "Invalid date: " + string)
        }
        return date
    }
}

extension Date {
    func timeAgo(since date: Date = Date()) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Calendar.current.locale
        return formatter.localizedString(for: self, relativeTo: date)
    }
}

extension String {
    var lastPathComponent: String {
        let components = self.components(separatedBy: "/")
        return components.last ?? String()
    }
}

import UIKit.UIImageView

// FIXME: Find a better to handling image downloading
extension UIImageView {
    func load(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in

            guard let imageData = data else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        task.resume()
    }
}

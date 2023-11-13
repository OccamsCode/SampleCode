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

    func load(url: URL, placeholder: UIImage? = nil, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)

        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            if #available(iOS 15.0, *) {
                image.prepareForDisplay { newImage in
                    DispatchQueue.main.async {
                        self.image = newImage
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        } else {
            self.image = placeholder

            URLSession.shared.dataTask(with: request) { [weak self] (data, response, _) in
                guard let data = data,
                        let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode,
                        let image = UIImage(data: data) else { return }

                let cachedData = CachedURLResponse(response: httpResponse, data: data)
                cache.storeCachedResponse(cachedData, for: request)
                if #available(iOS 15.0, *) {
                    image.prepareForDisplay { newImage in
                        DispatchQueue.main.async {
                            self?.image = newImage
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }.resume()
        }
    }
}

import Foundation
import os.log

class Log {

    enum Level {
        case info
        case verbose
        case warning
        case error
        case none

        fileprivate var prefix: String {
            switch self {
            case .info:    return "INFO 💬"
            case .verbose: return "V.BOSE 🔊"
            case .warning: return "WARN ⚠️"
            case .error:   return "ERROR ❌"
            case .none:    return "🚫"
            }
        }
    }

    struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            return "\(file.lastPathComponent):\(line) \(function)"
        }
    }

    static let instance = Log()

    var level: Level = .none

    fileprivate func shouldLog(atLevel logLevel: Level) -> Bool {

        switch level {
        case .info:
            return true
        case .verbose:
            return Set<Level>([.warning, .error, .verbose]).contains(logLevel)
        case .warning:
            return Set<Level>([.warning, .error]).contains(logLevel)
        case .error:
            return logLevel == .error
        case .none:
            return false
        }
    }

    fileprivate func handle(_ level: Level, shouldLogContext: Bool, context: Context, args: Any) {

        guard shouldLog(atLevel: level) else { return }

        var items: [String] = []

        if shouldLogContext {
            items.append(context.description)
        }

        var argsOutput = String()

        if let argsArray = args as? [Any] {
            for arg in argsArray {
                if let string = arg as? String {
                    argsOutput += string
                } else {
                    argsOutput += "\(arg)"
                }
            }
        } else if let argsString = args as? String {
            argsOutput = argsString
        }

        items.append(argsOutput)

        let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.custom.app", category: level.prefix)
        os_log("# %{public}@ ", log: log, type: .info, items.joined(separator: " ") )

    }

    static func info(shouldLogContext: Bool = false,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line,
                     _ items: Any...) {
        let context = Context(file: file, function: function, line: line)
        Log.instance.handle(.info, shouldLogContext: shouldLogContext, context: context, args: items)
    }

    static func warning(shouldLogContext: Bool = false,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line,
                        _ items: Any...) {
        let context = Context(file: file, function: function, line: line)
        Log.instance.handle(.warning, shouldLogContext: shouldLogContext, context: context, args: items)
    }

    static func error(shouldLogContext: Bool = true,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line,
                      _ items: Any...) {
        let context = Context(file: file, function: function, line: line)
        Log.instance.handle(.error, shouldLogContext: shouldLogContext, context: context, args: items)
    }

    static func verbose(shouldLogContext: Bool = false,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line,
                        _ items: Any...) {
        let context = Context(file: file, function: function, line: line)
        Log.instance.handle(.verbose, shouldLogContext: shouldLogContext, context: context, args: items)
    }

}

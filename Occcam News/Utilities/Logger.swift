import Foundation
import os.log

enum Log {
    enum LogLevel {
        case info
        case warning
        case error
        case verbose
        
        fileprivate var prefix: String {
            switch self {
            case .info:    return "INFO 💬"
            case .warning: return "WARN ⚠️"
            case .error:   return "ERROR ❌"
            case .verbose: return "V.BOSE 🔊"
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
    
    fileprivate static func handle(_ level: LogLevel, shouldLogContext: Bool, context: Context, args: Any) {
        
        var items: [String] = []
        
        if shouldLogContext {
            items.append(context.description)
        }
        
        var argsOutput = ""
        
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
        
//        #if DEBUG
//        print(fullString)
//        #endif
        
    }
    
    static func info(shouldLogContext: Bool = false, file: String = #file, function: String = #function, line: Int = #line, _ items: Any...) {
        let context = Context(file: file, function: function, line: line)
        Log.handle(.info, shouldLogContext: shouldLogContext, context: context, args: items)
    }
    
    static func warning(shouldLogContext: Bool = false, file: String = #file, function: String = #function, line: Int = #line, _ items: Any...) {
        let context = Context(file: file, function: function, line: line)
        Log.handle(.warning, shouldLogContext: shouldLogContext, context: context, args: items)
    }
    
    static func error(shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line, _ items: Any...) {
        let context = Context(file: file, function: function, line: line)
        Log.handle(.error, shouldLogContext: shouldLogContext, context: context, args: items)
    }
    
    static func verbose(shouldLogContext: Bool = false, file: String = #file, function: String = #function, line: Int = #line, _ items: Any...) {
        let context = Context(file: file, function: function, line: line)
        Log.handle(.verbose, shouldLogContext: shouldLogContext, context: context, args: items)
    }
    
}

import XCTest
import Swifter

class DynamicStubs {

    let server = HttpServer()

    func stubRequest(path: String, jsonData: Data) {

        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            assertionFailure("Could not convert data to json")
            return
        }

        let response: ((HttpRequest) -> HttpResponse) = { _ in
            HttpResponse.ok(.json(json as AnyObject))
        }

        server.get[path] = response
    }

}

class UITest: XCTestCase {

    let stubs = DynamicStubs()
    lazy var app = XCUIApplication()

    let defaultLaunchArguments: [String] = {
        let launchArguments: [String] = ["--uitest"]
        return launchArguments
    }()

    func launchApp(with launchArguments: [String] = []) {
        (defaultLaunchArguments + launchArguments).forEach { app.launchArguments.append($0) }
        app.launch()
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        try? stubs.server.start()
    }

    override func tearDown() {
        stubs.server.stop()
        app.terminate()
        super.tearDown()
    }
}

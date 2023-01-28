import XCTest

// swiftlint:disable all
final class HomeFlowTests: UITest {

    func testGoingThrough() {
        
        let type = type(of: self)
        let bundle = Bundle(for: type.self)
        let path = bundle.url(forResource: "responseTopHeadlines", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        
        stubs.stubRequest(path: "/v1/news/top", jsonData: data)
        
        launchApp(with: defaultLaunchArguments)
        
        sleep(10)
    }
}

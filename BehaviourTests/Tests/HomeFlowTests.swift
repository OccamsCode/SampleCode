import XCTest

// swiftlint:disable all
final class HomeFlowTests: UITest, HomeFlow {

    func testGoingThrough() {
        
        let type = type(of: self)
        let bundle = Bundle(for: type.self)
        let path = bundle.url(forResource: "responseTopHeadlines", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        
        stubs.stubRequest(path: "/api/v4/top-headlines", jsonData: data)
        
        launchApp(with: defaultLaunchArguments)
        
        XCTContext.runActivity(named: "Displays Home Screen") { _ in
            thenIShouldSeeHomeScreen()
        }
    }
}

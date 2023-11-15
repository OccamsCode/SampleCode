//
//  XCTest+Extension.swift
//  AppTests
//
//  Created by Brian Munjoma on 15/11/2023.
//

import XCTest

extension XCTestCase {

    private var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }

    func decodeModel<Model: Decodable>(_ verificationBlock: (Model) -> Void) throws {
        let bundle = Bundle(for: type(of: self))
        let fileName = String(describing: Model.self)

        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            return XCTFail("Unable to find file \(fileName).json")
        }

        let json = try Data(contentsOf: url)
        let instance: Model

        do {
            instance = try decoder.decode(Model.self, from: json)
            verificationBlock(instance)
        } catch {
            return XCTFail("Decoding Error: \(error.localizedDescription)")
        }
    }
}

//
//  CatogramTests.swift
//  CatogramTests
//
//  Created by Олег Крылов on 02/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import XCTest
@testable import Catogram

class CatogramTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testSomeInternetAction() {
        let imageDownloader = ImageDownloader()
        let url = "https://cdn2.thecatapi.com/images/bjb.jpg"
        var resultImage =  UIImage()

        imageDownloader.getPhoto(url: url) { result in
            switch result {
            case .success(let response):
                resultImage = response!
            case .failure(let error):
                print(error)
            }
        XCTAssert(resultImage == UIImage(named: "bjb", in: .main, compatibleWith: nil))
        }
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

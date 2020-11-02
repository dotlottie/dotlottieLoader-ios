import XCTest
@testable import dotLottieLoader

class Tests: XCTestCase {
    
    func testLoadDotLottie() {
        let expectation = XCTestExpectation(description: "Load dotlottie file")
            
        DotLottieLoader.load(from: URL(string: "https://dotlottie.io/sample_files/animation.lottie")!) { (lottie) in
            XCTAssertNotNil(lottie)
            XCTAssertNotNil(lottie?.manifest)
            
            XCTAssertEqual(lottie?.manifest?.animations.count, lottie?.animations.count)
            XCTAssertEqual("\(lottie?.manifest?.animations.first?.id ?? "").json", lottie?.animations.first?.lastPathComponent)
            XCTAssertEqual(lottie?.animationUrl, lottie?.animations.first)
            
            XCTAssertEqual(lottie?.animations.count, 1)
            XCTAssertEqual(lottie?.animations.first?.lastPathComponent, "lf20_gOmta2.json")
            
            XCTAssertEqual(lottie?.images.count, 0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLoadDotLottieWithExternalImage() {
        let expectation = XCTestExpectation(description: "Load dotlottie file with external image")
            
        DotLottieLoader.load(from: URL(string: "https://dotlottie.io/sample_files/animation-external-image.lottie")!) { (lottie) in
            XCTAssertNotNil(lottie)
            XCTAssertNotNil(lottie?.manifest)
            
            XCTAssertEqual(lottie?.animations.count, 1)
            XCTAssertEqual(lottie?.animations.first?.lastPathComponent, "with_image.json")
            
            XCTAssertEqual(lottie?.images.count, 1)
            XCTAssertEqual(lottie?.images.first?.lastPathComponent, "img_0.png")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLoadDotLottieWithInlineImage() {
        let expectation = XCTestExpectation(description: "Load dotlottie file with inline image")
            
        DotLottieLoader.load(from: URL(string: "https://dotlottie.io/sample_files/animation-inline-image.lottie")!) { (lottie) in
            XCTAssertNotNil(lottie)
            XCTAssertNotNil(lottie?.manifest)
            
            XCTAssertEqual(lottie?.animations.count, 1)
            XCTAssertEqual(lottie?.animations.first?.lastPathComponent, "lf20_I2I090.json")
            
            XCTAssertEqual(lottie?.images.count, 1)
            XCTAssertEqual(lottie?.images.first?.lastPathComponent, "image_0.png")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}

import XCTest
@testable import dotLottieLoader

class Tests: XCTestCase {
    
    func testLoadDotLottie() {
        let expectation = XCTestExpectation(description: "Load dotlottie file")
            
        DotLottieLoader.loadedFrom(url: URL(string: "https://dotlottie.io/sample_files/animation.lottie")!) { result in
            switch result {
            case .success(let lottie):
                XCTAssertEqual(lottie.animations.count, 1)
                XCTAssertEqual(lottie.animations.first?.animationUrl.lastPathComponent, "lf20_gOmta2.json")
                
            case .failure(let failure):
                XCTFail("Invalid file: \(failure.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLoadDotLottieWithExternalImage() {
        let expectation = XCTestExpectation(description: "Load dotlottie file with external image")
            
        DotLottieLoader.loadedFrom(url: URL(string: "https://dotlottie.io/sample_files/animation-external-image.lottie")!) { result in
            switch result {
            case .success(let lottie):
                XCTAssertEqual(lottie.animations.count, 1)
                XCTAssertEqual(lottie.animations.first?.animationUrl.lastPathComponent, "with_image.json")
                
            case .failure(let failure):
                XCTFail("Invalid file: \(failure.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLoadDotLottieWithInlineImage() {
        let expectation = XCTestExpectation(description: "Load dotlottie file with inline image")
            
        DotLottieLoader.loadedFrom(url: URL(string: "https://dotlottie.io/sample_files/animation-inline-image.lottie")!) { result in
            switch result {
            case .success(let lottie):
                XCTAssertEqual(lottie.animations.count, 1)
                XCTAssertEqual(lottie.animations.first?.animationUrl.lastPathComponent, "lf20_I2I090.json")
                
            case .failure(let failure):
                XCTFail("Invalid file: \(failure.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}

//
//  ImageCacheTest.swift
//
//
//  Created by Brent Mifsud on 2020-10-31.
//

@testable import Tendr
import XCTest
import Combine

class ImageCacheTest: XCTestCase {
    let sut = ImageCache.shared
    var cancellable: AnyCancellable?
    
    func testAddImageToCache() {
        let image = UIImage(systemName: "photo")!
        sut.set(forKey: "test", image: image)
        
        XCTAssertNotNil(sut.get(forKey: "test"))
    }
    
    func testRemoveImageFromCache() {
        let image = UIImage(systemName: "photo")!
        sut.set(forKey: "test", image: image)
        sut.remove(forKey: "test")
        
        XCTAssertNil(sut.get(forKey: "test"))
    }
    
    func testMemoryWarningClear() {
        let image = UIImage(systemName: "photo")!
        let image2 = UIImage(systemName: "photo.fill")!
        
        sut.set(forKey: "test", image: image)
        sut.set(forKey: "test2", image: image2)
        
        let exp = expectation(description: "wait to clear cache")
        
        cancellable = NotificationCenter.default
            .publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink(receiveValue: { _ in
                exp.fulfill()
            })
        
        NotificationCenter.default
            .post(
                name: UIApplication.didReceiveMemoryWarningNotification,
                object: nil
            )
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(sut.get(forKey: "test"))
        XCTAssertNil(sut.get(forKey: "test2"))
    }
}

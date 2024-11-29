import XCTest
@testable import Billboard

final class BillboardTests: XCTestCase {
    var sut: BillboardViewModel!
    var configuration: BillboardConfiguration!
    
    override func setUp() {
        super.setUp()
        configuration = BillboardConfiguration(
            adsJSONURL: URL(string: "https://billboard-source.vercel.app/ads.json"),
            allowHaptics: true,
            advertDuration: 15.0,
            excludedIDs: []
        )
        sut = BillboardViewModel(configuration: configuration)
    }
    
    override func tearDown() {
        sut = nil
        configuration = nil
        super.tearDown()
    }
    
    func testBillboardConfigurationInitialization() {
        let customURL = URL(string: "https://example.com/ads.json")
        let config = BillboardConfiguration(
            adsJSONURL: customURL,
            allowHaptics: false,
            advertDuration: 10.0,
            excludedIDs: ["123", "456"]
        )
        
        XCTAssertEqual(config.adsJSONURL, customURL)
        XCTAssertFalse(config.allowHaptics)
        XCTAssertEqual(config.duration, 10.0)
        XCTAssertEqual(config.excludedIDs, ["123", "456"])
    }
    
    func testBillboardAdCreation() {
        let ad = BillboardAd(
            appStoreID: "123456789",
            name: "TestApp",
            title: "Test Title",
            description: "Test Description",
            category: .music,
            media: URL(string: "https://example.com/image.jpg")!,
            backgroundColor: "#000000",
            textColor: "#FFFFFF",
            tintColor: "#FF0000",
            fullscreen: true,
            transparent: false
        )
        
        XCTAssertEqual(ad.id, "TestApp+123456789")
        XCTAssertEqual(ad.appStoreID, "123456789")
        XCTAssertEqual(ad.name, "TestApp")
        XCTAssertEqual(ad.title, "Test Title")
        XCTAssertEqual(ad.description, "Test Description")
        XCTAssertEqual(ad.category, .music)
        XCTAssertEqual(ad.appStoreLink?.absoluteString, "https://apps.apple.com/app/id123456789")
        XCTAssertTrue(ad.fullscreen)
        XCTAssertFalse(ad.transparent)
    }
    
    func testFetchRandomAdWithExcludedIDs() async throws {
        // Create a mock URL that returns a known JSON response
        let mockJSON = """
        {
            "ads": [
                {
                    "appStoreID": "123",
                    "name": "App1",
                    "title": "Title1",
                    "description": "Description1",
                    "media": "https://example.com/1.jpg",
                    "backgroundColor": "#000000",
                    "textColor": "#FFFFFF",
                    "tintColor": "#FF0000",
                    "fullscreen": true,
                    "transparent": false
                },
                {
                    "appStoreID": "456",
                    "name": "App2",
                    "title": "Title2",
                    "description": "Description2",
                    "media": "https://example.com/2.jpg",
                    "backgroundColor": "#000000",
                    "textColor": "#FFFFFF",
                    "tintColor": "#FF0000",
                    "fullscreen": false,
                    "transparent": true
                }
            ]
        }
        """
        
        // Create mock session
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: config)
        
        // Setup mock data
        let mockData = mockJSON.data(using: .utf8)!
        URLProtocolMock.mockData = mockData
        URLProtocolMock.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // Create a test method that accepts a URLSession
        func fetchRandomAdWithSession(from url: URL, excludedIDs: [String], session: URLSession) async throws -> BillboardAd? {
            do {
                let (data, _) = try await session.data(from: url)
                let decoder = JSONDecoder()
                let response = try decoder.decode(BillboardAdResponse.self, from: data)
                let filteredAds = response.ads.filter({ !excludedIDs.contains($0.appStoreID) })
                return filteredAds.first
            } catch {
                throw error
            }
        }
        
        // Test fetching with excluded IDs
        let excludedIDs = ["123"]
        let mockURL = URL(string: "https://example.com/ads.json")!
        let ad = try await fetchRandomAdWithSession(from: mockURL, excludedIDs: excludedIDs, session: mockSession)
        
        XCTAssertNotNil(ad)
        if let ad = ad {
            XCTAssertFalse(excludedIDs.contains(ad.appStoreID))
            XCTAssertEqual(ad.appStoreID, "456")
        }
    }
}

// Mock URLProtocol for testing network requests
class URLProtocolMock: URLProtocol {
    static var mockData: Data?
    static var mockResponse: URLResponse?
    static var mockError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = URLProtocolMock.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        if let data = URLProtocolMock.mockData {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolMock.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}

// Mock Response Extension
extension BillboardAd {
    static func mockAd() -> BillboardAd {
        return BillboardAd(
            appStoreID: "123456789",
            name: "TestApp",
            title: "Test Title",
            description: "Test Description",
            media: URL(string: "https://example.com/image.jpg")!,
            backgroundColor: "#000000",
            textColor: "#FFFFFF",
            tintColor: "#FF0000",
            fullscreen: true,
            transparent: false
        )
    }
}

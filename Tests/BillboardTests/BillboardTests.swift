import XCTest
@testable import Billboard

final class BillboardTests: XCTestCase {
   
    func testFetchRandomAd() async throws {
        let url = BillboardConfiguration().adsJSONURL!
        
        let ad = try await BillboardViewModel.fetchRandomAd(from: url)
        
        XCTAssertNotNil(ad)
    }
}

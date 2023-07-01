import XCTest
@testable import Billboard

final class BillboardTests: XCTestCase {
   
       
    func testFetchRandomAd() async throws {
        guard let url = BillboardConfiguration().adsJSONURL else {
            return
        }
        
        let ad = try await BillboardViewModel.fetchRandomAd(from: url)
        XCTAssertNotNil(ad)
    }
    
    func testShowAdvertisement() async throws {
        let viewmodel = BillboardViewModel()
        await viewmodel.showAdvertisement()
        XCTAssertNotNil(viewmodel.advertisement)
    }
}

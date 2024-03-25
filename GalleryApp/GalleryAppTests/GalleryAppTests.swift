import XCTest
import Combine
@testable import GalleryApp

final class GalleryAppTests: XCTestCase {
    
    var imageGalleryScreenVM: ImageGalleryScreenViewModel!
    var coordinator: Coordinator!
    private var cancellable: Set<AnyCancellable> = []
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        imageGalleryScreenVM = ImageGalleryScreenViewModel()
        coordinator = Coordinator()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        imageGalleryScreenVM = nil
        coordinator = nil
        try super.tearDownWithError()
    }
    
    func testAPICall() throws {
        imageGalleryScreenVM.getDataFromApi()
        let expectation = self.expectation(description: "Api call")
        
        imageGalleryScreenVM.$photos
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
        XCTAssert(imageGalleryScreenVM.photos.count == 30, "Count of photos from API")
    }
    
    func testFavouriteDictCreation() throws {
        
        let photoArray = [PhotoArray(id: "qwerty",
                                     width: 1024,
                                     height: 1024,
                                     description: "Test",
                                     user: UserModel(username: "Test"),
                                     urls: UrlsModel(regular: "url",
                                                     small: "url"))]
        imageGalleryScreenVM.databasePhotos = photoArray
        imageGalleryScreenVM.getDataFromDatabase()
        
        XCTAssert(imageGalleryScreenVM.favouriteDict["qwerty"] == true, "favouriteDict")
        
    }
    
    func testCoordinator() throws {
        coordinator?.start()
        coordinator?.pushDetailsView(id: 1, photos: [], page: 1, favouriteDict: [:], isFavScreen: true)
        coordinator?.backToMainView(id: 1, photos: [], page: 1, favouriteDict: [:])
        XCTAssert(coordinator.navigationController.viewControllers.count == 1, "Num of vc")
    }
    
    func testPerformanceAPICall() throws {
        // This is an example of a performance test case.
        imageGalleryScreenVM.getDataFromApi()
        
        measure {
            let expectation = self.expectation(description: "Api call time")
            imageGalleryScreenVM.$photos
                .filter { !$0.isEmpty }
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    expectation.fulfill()
                }.store(in: &cancellable)
            
            waitForExpectations(timeout: 10)
        }
    }
    
}

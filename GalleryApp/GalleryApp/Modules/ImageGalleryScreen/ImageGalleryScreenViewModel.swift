import Foundation
import Combine

protocol ImageGalleryScreenViewModelProtocol {
    func getData()
}

final class ImageGalleryScreenViewModel: ImageGalleryScreenViewModelProtocol {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    private var cancellable: Set<AnyCancellable> = []
    @Published var photos: [PhotoList] = [] {
        didSet {
            print(photos.first?.description)
        }
    }
    func getData() {
        apiService.getPhotos(page: 1)
            .sink { error in
                print(error)
            } receiveValue: { photos in
                self.photos = photos
            }.store(in: &cancellable)

    }
}

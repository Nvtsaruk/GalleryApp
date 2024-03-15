import Foundation
import Combine
protocol ImageGalleryScreenViewModelProtocol {
    func getData()
    var photosPublisher: Published<[PhotoList]>.Publisher { get }
}

final class ImageGalleryScreenViewModel: ImageGalleryScreenViewModelProtocol {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    private var cancellable: Set<AnyCancellable> = []
    @Published var photos: [PhotoList] = [] 
    var photosPublisher: Published<[PhotoList]>.Publisher { $photos }
    func getData() {
        apiService.getPhotos(page: 1)
            .sink { error in
                print(error)
            } receiveValue: { photos in
                self.photos = photos
            }.store(in: &cancellable)

    }
}

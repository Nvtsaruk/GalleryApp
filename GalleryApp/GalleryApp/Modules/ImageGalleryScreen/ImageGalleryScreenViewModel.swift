import Foundation
import Combine

protocol ImageGalleryScreenViewModelProtocol {
    func getData()
    var photosPublisher: Published<[PhotoList]>.Publisher { get }
}

final class ImageGalleryScreenViewModel {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    private var cancellable: Set<AnyCancellable> = []
    @Published var photos: [PhotoArray] = []
    @Published var id = 0
    var page = 1
    func getData() {
        apiService.getPhotos(page: page)
            .sink { error in
                print(error)
            } receiveValue: { photos in
                self.photos.append(contentsOf: photos)
            }.store(in: &cancellable)
    }
    
    func pushDetails(id: Int) {
        coordinator?.pushDetailsView(id: id, photos: photos, page: page)
    }
}

import Foundation
import Combine

final class ImageGalleryScreenViewModel {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    private var cancellable: Set<AnyCancellable> = []
    @Published var photos: [PhotoList] = [] 
    func getData() {
        apiService.getPhotos(page: 1)
            .sink { error in
                print(error)
            } receiveValue: { photos in
                self.photos = photos
            }.store(in: &cancellable)

    }
}

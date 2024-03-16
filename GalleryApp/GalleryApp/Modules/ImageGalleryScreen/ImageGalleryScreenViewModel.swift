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
    @Published var photos: [PhotoArray] = [] {
        didSet {
            print(photos.count)
        }
    }
    var page = 1 {
        didSet {
            print(page)
        }
    }
//    var photosPublisher: Published<[PhotoList]>.Publisher { $photos }
    func getData() {
        apiService.getPhotos(page: page)
            .sink { error in
                print(error)
            } receiveValue: { photos in
                self.photos.append(contentsOf: photos)
            }.store(in: &cancellable)
    }
    
    func pushDetails(id: Int) {
        print(id)
        coordinator?.pushDetailsView(id: id, photos: photos)
    }
}

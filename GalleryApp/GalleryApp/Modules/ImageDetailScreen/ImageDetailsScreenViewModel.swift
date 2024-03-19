import Foundation
import Combine

final class ImageDetailsScreenViewModel {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    @Published var photos: [PhotoArray] = [] 
    private var cancellable: Set<AnyCancellable> = []
    var id = 0
    var currentImage: Data?
    
    var page = 1
    func getData() {
        apiService.getPhotos(page: page)
            .sink { error in
                print(error)
            } receiveValue: { photos in
                self.photos.append(contentsOf: photos)
            }.store(in: &cancellable)
    }

}

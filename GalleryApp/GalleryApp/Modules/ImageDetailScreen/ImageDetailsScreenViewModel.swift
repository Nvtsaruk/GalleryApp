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
    func toggleFavourites() {
        if photos[id].likedByUser ?? false {
            DatabaseService.shared.deleteFromDatabase(id: photos[id].id)
            photos[id].likedByUser?.toggle()
        } else {
//            DatabaseService.shared.addToDatabase(photos: photos[id])
            photos[id].likedByUser?.toggle()
        }
    }

    func backToMainView() {
        coordinator?.backToMainView(id: id, photos: photos, page: page)
    }

}

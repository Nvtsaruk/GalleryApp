import Foundation
import Combine

final class ImageDetailsScreenViewModel {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    @Published var photos: [PhotoArray] = []
    private var cancellable: Set<AnyCancellable> = []
    var id = 0
    var isFavourite = false
    var page = 1
    func getData() {
        apiService.getPhotos(page: page)
            .sink { error in
                print(error)
            } receiveValue: { photos in
                self.photos.append(contentsOf: photos)
            }.store(in: &cancellable)
    }
    func toggleFavourites(regularImage: Data?) {
        if photos[id].likedByUser ?? false {
            DatabaseService.shared.deleteFromDatabase(id: photos[id].id)
            photos[id].likedByUser?.toggle()
        } else {
            guard let regularImage = regularImage else { return }
            saveToLocalStorage(image: regularImage)
            DatabaseService.shared.addToDatabase(photos: photos[id], imageUrlRegular: photos[id].id)
            photos[id].likedByUser = true
        }
    }
    
    private func saveToLocalStorage(image: Data) {
        LocalStorageService.shared.store(image: image, forKey: photos[id].id)
    }

    func backToMainView() {
        coordinator?.backToMainView(id: id, photos: isFavourite ? photos : nil, page: page)
    }

}

import Foundation
import Combine

final class ImageDetailsScreenViewModel {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    @Published var photos: [PhotoArray] = []
    var favouriteDict: [String: Bool] = [:]
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
        if favouriteDict[photos[id].id] ?? false {
            DatabaseService.shared.deleteFromDatabase(id: photos[id].id)
            LocalStorageService.shared.removeImage(forKey: photos[id].id)
            favouriteDict.removeValue(forKey: photos[id].id)
            photos[id].needUpdate = false
        } else {
            guard let regularImage = regularImage else { return }
            saveToLocalStorage(image: regularImage)
            DatabaseService.shared.addToDatabase(photos: photos[id], imageUrlRegular: photos[id].id)
            photos[id].needUpdate = true
            favouriteDict[photos[id].id] = true
        }
    }
    
    private func saveToLocalStorage(image: Data) {
        LocalStorageService.shared.store(image: image, forKey: photos[id].id)
    }

    func backToMainView() {
        coordinator?.backToMainView(id: id,
                                    photos: isFavourite ? nil : photos,
                                    page: page,
                                    favouriteDict: favouriteDict)
    }

}

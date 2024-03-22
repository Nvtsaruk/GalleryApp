import Foundation
import Combine

final class ImageGalleryScreenViewModel {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    private var cancellable: Set<AnyCancellable> = []
    @Published var photos: [PhotoArray] = []
    @Published var databasePhotos: [PhotoArray] = []
    @Published var id = 0
    var page = 1
    func getData() {
        getDataFromApi()
        getDataFromDatabase()
    }
    func getDataFromApi() {
        apiService.getPhotos(page: page)
            .sink { error in
                print(error)
            } receiveValue: { photos in
                self.photos.append(contentsOf: photos)
            }.store(in: &cancellable)
    }
    
    func getDataFromDatabase() {
        databasePhotos = DatabaseService.shared.getAllPhotos()
        let observer = DatabaseService.shared.observe()
        addFavs()
    }
    private func addFavs() {
        databasePhotos.forEach { item in
            guard let index = (getArrayIndex(item: item)) else { return }
            photos[index].likedByUser = item.likedByUser
        }
    }
    func getArrayIndex(item: PhotoArray) -> Int? {
        return photos.firstIndex(where: {$0.id == item.id})
    }
    
    func pushDetails(id: Int, isFavorite: Bool) {
        if !isFavorite {
            coordinator?.pushDetailsView(id: id, photos: photos, page: page, isFavourite: isFavorite)
        } else {
            coordinator?.pushDetailsView(id: id, photos: databasePhotos, page: page, isFavourite: isFavorite)
        }
    }
}

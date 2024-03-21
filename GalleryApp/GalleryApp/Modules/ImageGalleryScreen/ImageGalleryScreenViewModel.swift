import Foundation
import Combine

protocol ImageGalleryScreenViewModelProtocol {
    func getData()
    var photosPublisher: Published<[PhotoArray]>.Publisher { get }
}

final class ImageGalleryScreenViewModel {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    private var cancellable: Set<AnyCancellable> = []
    @Published var photos: [PhotoArray] = []
    var databasePhotos: [PhotoArray] = []
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
        print(DatabaseService.shared.getAllPhotos().count)
        databasePhotos = DatabaseService.shared.getAllPhotos()
        addFavs()
    }
    private func addFavs() {
        databasePhotos.forEach { item in
            let index = (getArrayIndex(item: item))
            photos[index ?? 0].likedByUser = item.likedByUser
        }
    }
    func getArrayIndex(item: PhotoArray) -> Int? {
        return photos.firstIndex(where: {$0.id == item.id})
    }
    
    func pushDetails(id: Int) {
        coordinator?.pushDetailsView(id: id, photos: photos, page: page)
    }
}

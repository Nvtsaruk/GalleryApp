import Foundation
import Combine

final class ImageGalleryScreenViewModel {
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    private var cancellable: Set<AnyCancellable> = []
    @Published var photos: [PhotoArray] = []
    @Published var databasePhotos: [PhotoArray] = [] {
        didSet {
            print(databasePhotos.count)
//            addFavs()
        }
    }
    @Published var id = 0
    var page = 1
    func getData() {
        getDataFromApi()
        getDataFromDatabase()
    }
    func getDataFromApi() {
        apiService.getPhotos(page: page)
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] photos in
                self?.photos.append(contentsOf: photos)
            }.store(in: &cancellable)
    }
    
    func getDataFromDatabase() {
        DatabaseService.shared.getAllPhotos()
        DatabaseService.shared.$photos
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] photos in
                self?.databasePhotos = photos
                self?.addFavs()
            }.store(in: &cancellable)
        addFavs()
    }

    private func addFavs() {
        photos.indices.forEach {
            photos[$0].likedByUser = nil
        }
        databasePhotos.forEach { item in
            print("in For each", databasePhotos.count)
            guard let index = (getArrayIndex(item: item)) else { return }
            photos[index].likedByUser = item.likedByUser
        }
    }
    func getArrayIndex(item: PhotoArray) -> Int? {
        return photos.firstIndex(where: {$0.id == item.id})
    }
    
    func pushDetails(id: Int, isFavorite: Bool) {
        if !isFavorite {
            coordinator?.pushDetailsView(id: id, photos: photos, page: page)
        } else {
            coordinator?.pushDetailsView(id: id, photos: databasePhotos, page: page)
        }
    }
}

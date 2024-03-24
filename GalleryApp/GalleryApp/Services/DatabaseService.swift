import RealmSwift
import Combine

final class DatabaseService {
    static var shared = DatabaseService()
    private init() {}
    
    @Published var photos: [PhotoArray] = []
    
    let realm = try? Realm()
    
    func addToDatabase(photos: PhotoArray, imageUrlRegular: String) {
        var dbPhotos = DatabasePhotos()
        let modelToDatabase = ModelToDatabase(photos: photos)
        dbPhotos = modelToDatabase.modelToDatabase()
        dbPhotos.needUpdate = true
        dbPhotos.localUrlRegular = imageUrlRegular
        try? realm?.write {
            realm?.add(dbPhotos)
        }
        getAllPhotos()
    }
    
    func getAllPhotos() {
        var allPhotos: [PhotoArray] = []
        let dbPhotos = realm?.objects(DatabasePhotos.self)
        dbPhotos?.forEach { photo in
            guard let dbMap = DatabaseToModel(dbPhotos: photo).databaseToModel() else { return }
            allPhotos.append(dbMap)
        }
        photos = allPhotos
    }
    
    func deleteFromDatabase(id: String) {
        try? realm?.write {
            let dbPhotos = realm?.objects(DatabasePhotos.self).where {
                $0.id == id
            }
            guard let dbPhotos = dbPhotos else { return }
            realm?.delete(dbPhotos)
            getAllPhotos()
        }
        
    }
}

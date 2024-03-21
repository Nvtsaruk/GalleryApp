import RealmSwift

final class DatabaseService {
    static var shared = DatabaseService()
    private init() {}
    
    let realm = try? Realm()
    
    func addToDatabase(photos: PhotoArray, imageUrlSmall: String, imageUrlRegular: String) {
        var dbPhotos = DatabasePhotos()
        let modelToDatabase = ModelToDatabase(photos: photos)
        dbPhotos = modelToDatabase.modelToDatabase()
        dbPhotos.likedByUser = true
        dbPhotos.localUrlRegular = imageUrlRegular
        dbPhotos.localUrlSmall = imageUrlSmall
        try? realm?.write {
            realm?.add(dbPhotos)
        }
    }
    
    func getAllPhotos() -> [PhotoArray] {
        var allPhotos: [PhotoArray] = []
        let dbPhotos = realm?.objects(DatabasePhotos.self)
        dbPhotos?.forEach { photo in
            guard let dbMap = DatabaseToModel(dbPhotos: photo).databaseToModel() else { return }
            allPhotos.append(dbMap)
        }
        return allPhotos
    }
    func deleteFromDatabase(id: String) {
        try? realm?.write {
            let dbPhotos = realm?.objects(DatabasePhotos.self).where {
                $0.id == id
            }
            guard let dbPhotos = dbPhotos else { return }
            realm?.delete(dbPhotos)
        }
    }
}

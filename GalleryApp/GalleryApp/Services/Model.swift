import Foundation

struct PhotoArray: Decodable {
    let uuid = UUID()
    var needUpdate: Bool?
    let id: String
    let width: Int
    let height: Int
    let description: String?
    var imageUrlRegular: String?
    let user: UserModel
    let urls: UrlsModel
}
extension PhotoArray: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    static func == (lhs: PhotoArray, rhs: PhotoArray) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.needUpdate == rhs.needUpdate
    }
}

struct UrlsModel: Decodable, Hashable {
    let regular: String
    let small: String
}

struct UserModel: Decodable {
    var username: String
}

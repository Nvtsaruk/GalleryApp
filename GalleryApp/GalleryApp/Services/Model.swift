import Foundation

struct PhotoArray: Decodable, Hashable {
    let id: String
    struct Urls: Decodable, Hashable {
        var regular: String
    }
    var description: String?
    let urls: Urls
}

struct PhotoList: Decodable {
    var id: String
//    var slug: String
    var created_at: String
    var updated_at: String
    var width: Int
    var height: Int
//    var color: String
//    var blur_hash: String
    var likes: Int
//    var liked_by_user: Bool
    var description: String?
//    var user: User
    var urls: Urls
    //        "current_user_collections": [ // The *current user's* collections that this photo belongs to.
    //          {
    //            "id": 206,
    //            "title": "Makers: Cat and Ben",
    //            "published_at": "2016-01-12T18:16:09-05:00",
    //            "last_collected_at": "2016-06-02T13:10:03-04:00",
    //            "updated_at": "2016-07-10T11:00:01-05:00",
    //            "cover_photo": null,
    //            "user": null
    //          },
    //          // ... more collections
    //        ],
    //        "urls": {
    //          "raw": "https://images.unsplash.com/face-springmorning.jpg",
    //          "full": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg",
    //          "regular": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=1080&fit=max",
    //          "small": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=400&fit=max",
    //          "thumb": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=200&fit=max"
    //        },
    //        "links": {
    //          "self": "https://api.unsplash.com/photos/LBI7cgq3pbM",
    //          "html": "https://unsplash.com/photos/LBI7cgq3pbM",
    //          "download": "https://unsplash.com/photos/LBI7cgq3pbM/download",
    //          "download_location": "https://api.unsplash.com/photos/LBI7cgq3pbM/download"
    //        }
    //      },
    //      // ... more photos
}
//extension PhotoList: Identifiable, Hashable {
//    var identifier: String {
//        return UUID().uuidString
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        return hasher.combine(identifier)
//    }
//    
//    public static func == (lhs: PhotoList, rhs: PhotoList) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//}
struct Urls: Decodable, Hashable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}

struct User: Decodable {
    var id: String
    var username: String
    var name: String
    var portfolio_url: String?
    var bio: String
    var location: String?
    var total_likes: Int
    var total_photos: Int
    var total_collections: Int
    var instagram_username: String?
    var twitter_username: String?
    //    "profile_image": {
    //      "small": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
    //      "medium": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
    //      "large": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
    //    },
    //    "links": {
    //      "self": "https://api.unsplash.com/users/poorkane",
    //      "html": "https://unsplash.com/poorkane",
    //      "photos": "https://api.unsplash.com/users/poorkane/photos",
    //      "likes": "https://api.unsplash.com/users/poorkane/likes",
    //      "portfolio": "https://api.unsplash.com/users/poorkane/portfolio"
    //    }
}

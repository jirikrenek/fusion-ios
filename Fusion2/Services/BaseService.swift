
import Foundation


enum ServiceError: Error {
    case loginCanceled
    case missingToken
    case wrongPhoneNumber
    case serializationError(message: String)
}

class BaseService {

    
    let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
}

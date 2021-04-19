//
//  NetworkManager.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import Foundation
import Alamofire

final class NetworkManager<T: Codable> {
    static func fetchData(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void ) {
        AF.request(urlString).responseDecodable(of: T.self) {
            (resp) in
            if resp.error != nil {
                completion(.failure(.invalidResp))
                print(resp.error!)
                return
            }
            // if no error and payload went through
            if let payload = resp.value {
//                print("payload success")
                completion(.success(payload))
                return
            }
            completion(.failure(.nullResp))
            
        }
        
    }
}

enum NetworkError: Error {
    case invalidResp
    case nullResp
}

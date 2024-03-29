//
//  GenericUseCase.swift
//  Practica_DisPatrones_AGGA
//
//  Created by Alejandro Alberto Gavira García on 24/1/24.
//

import Foundation

class APIProvider {
    
    static func getData<T: Decodable>(endpoint:String, dataRequest: String, value: String , completion: @escaping (Result<T, NetworkErrors>) -> Void) {
        
        //1.URL
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(endpoint)") else {
            completion(.failure(.malformedURL))
            return
        }
        
        //2. Token
        guard let token = LocalDataModel.getToken() else {
            completion(.failure(.tokenNotFound))
            return
        }
        
        //3.Query
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name:dataRequest, value:value)]
    
        //4. Body

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: HTTPMethods.auth)
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
   
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard statusCode == HTTPResponseCodes.SUCCESS else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let resource = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.failDecodingData))
                return
            }

            completion(.success(resource))
            
        }
        task.resume()
        
    }
    
}

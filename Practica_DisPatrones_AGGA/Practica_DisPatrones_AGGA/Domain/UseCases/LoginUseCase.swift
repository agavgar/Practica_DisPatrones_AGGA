//
//  LoginUseCase.swift
//  Practica_DisPatrones_AGGA
//
//  Created by Alejandro Alberto Gavira García on 23/1/24.
//

import Foundation

protocol LoginUseCaseProtocol {
    func login(user: String, password: String, completion: @escaping (Result<String, NetworkErrors>)-> Void)
}

final class LoginUseCase {
    
    func login(user: String, password: String, completion: @escaping (Result<String, NetworkErrors>)-> Void){
        
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.login.rawValue)") else {
            completion(.failure(.malformedURL))
            return
        }
        
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.failDecodingData))
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: HTTPMethods.auth)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == HTTPResponseCodes.SUCCESS else {
                completion(.failure(.statusCode(code: (response as? HTTPURLResponse)?.statusCode)))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(.failure(.tokenNotFound))
                return
            }
            
            LocalDataModel.save(token: token)
            completion(.success(token))
            
        }
        task.resume()
        
    }
    
    
}

//MARK: - LOGIN USE CASE FAKE SUCCESS
final class LoginUseCaseFakeSuccess: LoginUseCaseProtocol {
    func login(user: String, password: String, completion: @escaping (Result<String, NetworkErrors>)-> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let token = "fdsfsdhgj8sfd87sd67f6sdf78sd8f6efbw3"
            completion(.success(token))
        }
    }
}

//MARK: - LOGIN USE CASE FAKE ERROR
final class LoginUseCaseFakeError: LoginUseCaseProtocol {
    func login(user: String, password: String, completion: @escaping (Result<String, NetworkErrors>)-> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(.failure(.tokenNotFound))
        }
    }
}

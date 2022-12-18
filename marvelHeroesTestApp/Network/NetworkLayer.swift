//
//  NetworkLayer.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 09/12/2022.
//

import Foundation

enum NetworkRequestState {

    case idle
    case fetching
}

enum NetworkErrorCodes: Int {

    case authorization = 401
    case forbidden = 403
    case notFound = 404
}

enum NetworkErrors: Error{

    case badInput
    case noData
    case invalidURL
    case requestError(String)
}

protocol NetworkLayerDelegate: AnyObject {

    func hashGeneration(usingTimestamp timestamp: String, apikey: String, secret: String) -> String
}

final class NetworkLayer {

    fileprivate let networkConfig: NetworkAPIConfig
    fileprivate let session: URLSession
    fileprivate var networkDataTasks: [String: URLSessionDataTask] = [:]

    weak var delegate: NetworkLayerDelegate?

    required init(networkConfig: NetworkAPIConfig) {

        self.networkConfig = networkConfig
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }

    func execute<T: Decodable>(request: Request, completion: @escaping (Result<T, NetworkErrors>) -> Void) {

        //Cancel similar ongoing requests
        if let task = self.networkDataTasks[request.path] {

            task.cancel()
        }

        do {

            let request = try self.prepareURLRequest(for: request)

            let task = self.session.dataTask(with: request) { data, response, error in
                
                guard let data = data else {

                    return completion(.failure(.noData))
                }

                if let error = error {

                    return completion(.failure(.requestError(error.localizedDescription)))
                }

                if let statusCode = (response as? HTTPURLResponse)?.statusCode, let errorCode = NetworkErrorCodes(rawValue: statusCode) {

                    return completion(.failure(.requestError("Request error with status code: \(errorCode) - \(errorCode.rawValue)")))
                }

                do {

                    let decoder = JSONDecoder()
                    let objectRepresentation = try decoder.decode(T.self, from: data)

                    completion(.success(objectRepresentation))
                }
                catch let jsonError {
                    
                    print(jsonError)
                    return completion(.failure(.requestError("Decoding data error")))
                }

                self.networkDataTasks.removeValue(forKey: request.url!.absoluteString)
            }

            if let urlString = request.url?.absoluteString {
               
                self.networkDataTasks[urlString] = task
            }
            else {

                return completion(.failure(.badInput))
            }

            task.resume()
        }
        catch NetworkErrors.badInput {

            return completion(.failure(.requestError("Invalid request input parameters")))
        }
        catch NetworkErrors.noData {

            return completion(.failure(.requestError("No data returned from request")))
        }
        catch NetworkErrors.invalidURL {

            return completion(.failure(.requestError("Invalid request URL")))
        }
        catch {
            
            return completion(.failure(.requestError(error.localizedDescription)))
        }
    }

    fileprivate func prepareURLRequest(for request: Request) throws -> URLRequest {

        guard let url = URL(string: "\(networkConfig.baseUrl)/\(request.path)") else {

            throw NetworkErrors.invalidURL
        }

        var urlRequest = URLRequest(url: url)

        // Working with parameters
        switch request.parameters {

        case .body(let params):

            if let params = params as? [String: String] {

                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
            } else {

                throw NetworkErrors.badInput
            }

        case .url(let params):

            if let params = params as? [String: String] {

                let queryParams = params.map({ (element) -> URLQueryItem in

                    return URLQueryItem(name: element.key, value: element.value)
                })

                guard var components = URLComponents(string: url.absoluteString) else {

                    throw NetworkErrors.badInput
                }

                components.queryItems = queryParams
                urlRequest.url = components.url
            } else {

                throw NetworkErrors.badInput
            }

        case .none:

            break
        }

        if let delegate = delegate {

            // handles apiKey and hash
            if let apiKey = networkConfig.publicAPIKey,
               let secret = networkConfig.secret,
               let absoluteUrlString = urlRequest.url?.absoluteString {

                guard var components = URLComponents(string: absoluteUrlString) else {

                    throw NetworkErrors.badInput
                }

                var modifiedQueryItems = components.queryItems

                if modifiedQueryItems == nil {

                    modifiedQueryItems = [URLQueryItem]()
                }

                let timestamp = String.timestamp()
                let hash = delegate.hashGeneration(usingTimestamp:timestamp, apikey: apiKey, secret: secret)

                modifiedQueryItems?.append(URLQueryItem(name: "ts", value: timestamp))
                modifiedQueryItems?.append(URLQueryItem(name: "apikey", value: apiKey))
                modifiedQueryItems?.append(URLQueryItem(name: "hash", value: hash))

                components.queryItems = modifiedQueryItems
                urlRequest.url = components.url
            }
        }

        // Add headers from enviornment and request
        networkConfig.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }

        // Setup HTTP method
        urlRequest.httpMethod = request.method.rawValue

        return urlRequest
    }
}

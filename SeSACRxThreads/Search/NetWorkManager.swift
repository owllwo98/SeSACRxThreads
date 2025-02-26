//
//  NetWorkManager.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/24/25.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

/*
 completionHandler
 */

struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Decodable {
    let movieNm, openDt: String
}


final class NetWorkManager {
    
    static let shared = NetWorkManager()
    
    private init () {}
    
    //    func callBoxOffice(date: String, completionHandler: @escaping ((Result<Movie, APIError>) -> Void)) {
    //        let urlString =  "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b4126bd85d21685991482cd29b102fd8&targetDt=\(date)"
    //
    //        guard let url = URL(string: urlString) else {
    //            completionHandler(.failure(.invalidURL))
    //            return
    //        }
    //
    //        URLSession.shared.dataTask(with: url) { data, response, error in
    //            if let error = error {
    //                completionHandler(.failure(.unknownResponse))
    //                return
    //            }
    //
    //            guard let response = response as? HTTPURLResponse, (200...299)
    //                .contains(response.statusCode) else {
    //                completionHandler(.failure(.statusError))
    //                return
    //            }
    //
    //            // 실패시 nil 값만 출력되어 어떤 error 인지 모른다
    ////            if let data = data,
    ////               let appData = try? JSONDecoder().decode(Movie.self, from: data) {
    ////
    ////            }
    //
    //            if let data = data {
    //                do {
    //                    let result = try JSONDecoder().decode(Movie.self, from: data)
    //                    completionHandler(.success(result))
    //                } catch {
    //                    completionHandler(.failure(.unknownResponse))
    //                }
    //            } else {
    //                completionHandler(.failure(.unknownResponse))
    //            }
    //        }.resume()
    //    }
    
    func callBoxOffice(date: String) -> Observable<Movie> {
        
        return Observable<Movie>.create { value in
            
            let urlString =  "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b4126bd85d21685991482cd29b102fd8&targetDt=\(date)"
            
            guard let url = URL(string: urlString) else {
                value.onError(APIError.invalidURL)
                return Disposables.create {
                    print("끝!")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    value.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299)
                    .contains(response.statusCode) else {
                    value.onError(APIError.statusError)
                    return
                }
                
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(Movie.self, from: data)
                        
                        // 여기서 error 를 방출해서 부모 Observabel 인 input.searchBarTap 도 disposed 된다
                        value.onError(APIError.statusError)
//                        value.onNext(result)
                        // dispose 시켜줘야 함
//                        value.onCompleted()
                    } catch {
                        value.onError(APIError.unknownResponse)
                    }
                } else {
                    value.onError(APIError.unknownResponse)
                }
            }.resume()
            
            return Disposables.create {
                print("끝!")
            }
        }
    }
    
    
    // MARK: 성공했을때 Movie  -> Result
    func callBoxOfficeWithSingle(date: String) -> Single<Movie> {
        
        return Single<Movie>.create { value in
            
            let urlString =  "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b4126bd85d21685991482cd29b102fd8&targetDt=\(date)"
            
            guard let url = URL(string: urlString) else {
                value(.failure(APIError.invalidURL))
                return Disposables.create {
                    print("끝!")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    value(.failure(APIError.unknownResponse))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299)
                    .contains(response.statusCode) else {
                    value(.failure(APIError.statusError))
                    return
                }
                
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(Movie.self, from: data)
                        
                        value(.failure(APIError.statusError))
//                        value(.success(result))
                    } catch {
                        value(.failure(APIError.unknownResponse))
                    }
                } else {
                    value(.failure(APIError.unknownResponse))
                }
            }.resume()
            
            return Disposables.create {
                print("끝!")
            }
        }
    }
    
    func callBoxOfficeWithSingle2(date: String) -> Single<Result<Movie, APIError>> {
        
        return Single<Result<Movie, APIError>>.create { value in
            
            let urlString =  "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b4126bd85d21685991482cd29b102fd8&targetDt=\(date)"
            
            guard let url = URL(string: urlString) else {
                
                value(.success(.failure(.invalidURL)))
                return Disposables.create {
                    print("끝!")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    value(.success(.failure(.unknownResponse)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299)
                    .contains(response.statusCode) else {
                    
                    value(.success(.failure(.statusError)))
                    return
                }
                
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(Movie.self, from: data)
                        value(.success(.success(result)))
                    } catch {
                        value(.success(.failure(.unknownResponse)))
                    }
                } else {
                    value(.success(.failure(.unknownResponse)))
                }
            }.resume()
            
            return Disposables.create {
                print("끝!")
            }
        }
    }
}

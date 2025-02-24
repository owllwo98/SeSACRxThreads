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
                        value.onNext(result)
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
}

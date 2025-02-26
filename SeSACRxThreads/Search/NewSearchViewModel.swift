//
//  NewSearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/24/25.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa

final class NewSearchViewModel {
    
    struct Input {
        let searchBarTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    
    struct  Output {
        let list: Observable<[DailyBoxOfficeList]>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let list = PublishSubject<[DailyBoxOfficeList]>()
        
        input.searchBarTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let text = Int($0) else {
                    return 20250223
                }
                return text
            }
            .map { return "\($0)" }
            .flatMap { // 어짜피 value 인 Observable<Movie> 를 다시 구독해야 하니까 그냥 flatMap 사용
                
                // 여기서 error 를 방출해서 부모 Observabel 인 input.searchBarTap 도 disposed 된다
//                NetWorkManager.shared.callBoxOffice(date: $0)
//                    .debug("Movie")
//                    .do(onDispose: { print("Movie Dispose!") })
                
                // MARK: 1. default data 를 생성해서 error 대응
//                    .catch { error in
//                        print("movie error", error)
//                        let data = Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: []))
//                        return Observable.just(data)
//                    }
                
                // MARK: 2. error case 별로 error 대응
//                        switch error as? APIError {
//                        case .invalidURL:
//                        case .statusError:
//                        case .unknownResponse:
//                        default:
//                        }
//                    }
                
//                 Single 사용 네트워크 통신
//                NetWorkManager.shared.callBoxOfficeWithSingle(date: $0)
//                    .debug("Movie")
//                    .do(onDispose: { print("Movie Dispose!") })
//                    .catch { error in
//                        print("movie error", error)
//                        let data = Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: []))
//                        return Single.just(data)
//                    }
                
                
                NetWorkManager.shared.callBoxOfficeWithSingle2(date: $0)
            }
        // MARK: 데이터 스트림이 Observable.just(data) 로 바뀌어서 (just)그냥 한번 방출하고 onCompleted 되어서 onDispose 발생
//            .catch { error in
//                print("movie error", error)
//                let data = Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: []))
//                return Observable.just(data)
//            }
            .debug("tap")
            .subscribe(with: self) { owner, value in
//                dump(value)
                
                print("tap Next", value)
//                list.onNext(value.boxOfficeResult.dailyBoxOfficeList)
                
                switch value {
                case .success(let movie):
                    dump(movie)
                    list.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
                case .failure(let error):
                    dump(error)
                    list.onNext([])
                }
            } onError: { owner, error in
                print("onError")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(list: list)
    }
    
}

//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let nickname = PublishSubject<String>()
    //BehaviorSubject(value: "고래밥")
    
    // 랜덤 배열
    let recommandList = ["뽀로로", "상어", "악어", "고래", "칙촉", "추천"]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
       
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

        bind()
        
//        testBehaviorSubject()
        testPublishSubject()
    }
    
    func testBehaviorSubject() {
        // 초기값을 갖는게 차별점
        let subject = BehaviorSubject(value: 1)
        
        // subscribe 전에 emit 한 이벤트 중 마지막 하나는 저장 가능
        subject.onNext(2)
        subject.onNext(5)
        
        subject
            .subscribe(with: self) { owner, value in
                print(#function, value)
            } onError: { owner, error in
                print(#function, error)
            } onCompleted: { owner in
                print(#function, "onCompleted")
            } onDisposed: { owner in
                print(#function, "onDisposed")
            }.disposed(by: disposeBag)
        
        subject.onNext(7)
        subject.onNext(10)
        subject.onNext(22)
        subject.onCompleted()
        subject.onNext(45)
        subject.onNext(60)

    }
    
    func testPublishSubject() {
        let subject = PublishSubject<Int>()
        
        subject.onNext(2)
        subject.onNext(5)
        
        subject
            .subscribe(with: self) { owner, value in
                print(#function, value)
            } onError: { owner, error in
                print(#function, error)
            } onCompleted: { owner in
                print(#function, "onCompleted")
            } onDisposed: { owner in
                print(#function, "onDisposed")
            }.disposed(by: disposeBag)
        
        subject.onNext(7)
        subject.onNext(10)
        subject.onNext(22)
        subject.onCompleted()
        subject.onNext(45)
        subject.onNext(60)
    }
    
    func bind() {
        nickname.onNext("테스트1")
        nickname.onNext("테스트2")
        nickname.onNext("테스트3")
        
        nickname
            .subscribe(with: self) { owner, value in
                owner.nicknameTextField.text = value
            } onError: { owner, error in
                print("nickname onError")
            } onCompleted: { owner in
                print("nickname onCompleted")
            } onDisposed: { owner in
                print("nickname onDisposed")
            }.disposed(by: disposeBag)
        
        // map({}) == map {} -> @autoclosure
        nextButton.rx
            .tap
            .debug("-jack1-")
            .withUnretained(self) // 약한 참조를 통한 self 캡쳐 현상 방지.
            .debug("-jack2-")
            .map { owner, _ in // 함수 매개변수 안에 함수가 있다.
                let random = owner.recommandList.randomElement()!
                return random
            }
            .debug("-jack3-") // 아래에서 위로 구독을 전파한다 (다운스트림에서 업스트림)
//            .bind(to: nickname)
//            .disposed(by: disposeBag)
            .bind(with: self) { owner, value in
                print("nextButton Next")
                let random = owner.recommandList.randomElement()!
                owner.nickname.onNext(random)
                owner.nickname.onNext(value)
            }.disposed(by: disposeBag)
        
        
        // map 을 써도 되지만, 옵저버블 2개를 결합해볼 수도 있음
//        nextButton.rx.tap
////            .withLatestFrom(Observable.just(recommandList.randomElement()!))
////            .flatMapLatest{ _ in
////
////            }
//            .debug()
//            .bind(to: nickname)
//            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(BirthdayViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}

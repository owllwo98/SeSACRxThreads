//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SignUpViewController: UIViewController {

    let emailTextField = UITextField()
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    let emailPlaceholder = Observable.just("이메일을 입력해주세요")
    var disposeBag = DisposeBag()
    
    
    func bind() {
        emailPlaceholder
            .bind(to: emailTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        // 4자리 이상: 다음버튼 나타나고, 중복확인 버튼
        // 4자리 미만: 다음버튼 X, 중복확인 버튼 Click X
        
        emailTextField
            .rx
            .text
            .orEmpty
            .bind(with: self) { owner, value in
                if value.count >= 4 {
                    owner.nextButton.isHidden = false
                    owner.validationButton.isEnabled = true
                } else {
                    owner.nextButton.isHidden = true
                    owner.validationButton.isEnabled = false
                }
            }.disposed(by: disposeBag)
        
        let validation = emailTextField
            .rx
            .text
            .orEmpty
            .map {
                $0.count >= 4
            }
        
//        validation
//            .bind(to: nextButton.rx.isHidden)
//            .disposed(by: disposeBag)
        
//        validation
//            .bind(to: validationButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        validation
            .subscribe(with: self) { owner, value in
                print("validation next")
                owner.validationButton.isEnabled = value
            } onDisposed: { owner in
                print("Validation Disposed")
            }.disposed(by: disposeBag)

        
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
                print("중복확인 버튼 클릭")
                owner.disposeBag = DisposeBag()
            }.disposed(by: disposeBag)
        
    }
    
    func OperatorExample() {
        let itemA = [3, 5, 23, 8, 10, 22]
        
//        Observable.just(itemA)
//            .subscribe(with: self) { owner, value in
//                print("JUST \(value)")
//            } onError: { owner, error in
//                print(error)
//            } onCompleted: { owner in
//                print("JUST onCompleted")
//            } onDisposed: { owner in
//                print("JUST onDisposed")
//            }.disposed(by: disposeBag)
        
//        Observable.from(itemA)
//            .subscribe(with: self) { owner, value in
//                print("JUST \(value)")
//            } onError: { owner, error in
//                print(error)
//            } onCompleted: { owner in
//                print("JUST onCompleted")
//            } onDisposed: { owner in
//                print("JUST onDisposed")
//            }.disposed(by: disposeBag)
        
        Observable
            .repeatElement(itemA)
            .take(10)
            .subscribe(with: self) { owner, value in
                print("JUST \(value)")
            } onError: { owner, error in
                print(error)
            } onCompleted: { owner in
                print("JUST onCompleted")
            } onDisposed: { owner in
                print("JUST onDisposed")
            }.disposed(by: disposeBag)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        bind()
        OperatorExample()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}

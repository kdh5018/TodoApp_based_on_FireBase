//
//  LoginVC.swift
//  TodoApp_based_on_FireBase
//
//  Created by 김도훈 on 12/27/23.
//

import UIKit
import KakaoSDKUser

class LoginVC: UIViewController {
    
    var viewModel = ViewModel()
    
    @IBOutlet weak var loginWithKaKao: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        loginWithKaKao.addTarget(self, action: #selector(loginWithKaKaoId), for: .touchUpInside)
    }
    
    
    
    @objc func loginWithKaKaoId() {
        // 카카오톡 로그인 버튼을 누르면 실행되는 코드
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //let idToken = oAuthToken.idToken ?? ""
                    //let accessToken = oAuthToken.accessToken
                    
                    self.viewModel.kakaoGetUserInfo()
                }
            }
        }
    }
    
    
}

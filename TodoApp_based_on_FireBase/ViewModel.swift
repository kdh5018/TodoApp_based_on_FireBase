//
//  ViewModel.swift
//  TodoApp_based_on_FireBase
//
//  Created by 김도훈 on 12/27/23.
//

import Foundation
import KakaoSDKUser

class ViewModel {
    
    /// 사용자 정보 가져오기
    func kakaoGetUserInfo() {
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print(error)
            }
            
            let userName = user?.kakaoAccount?.name
            let userEmail = user?.kakaoAccount?.email
            let userGender = user?.kakaoAccount?.gender
            let userProfile = user?.kakaoAccount?.profile?.profileImageUrl
            let userBirthYear = user?.kakaoAccount?.birthyear
            
            let contentText =
            "user name : \(userName)\n userEmail : \(userEmail)\n userGender : \(userGender), userBirthYear : \(userBirthYear)\n userProfile : \(userProfile)"
            
            print("user - \(user)")
            
            if userEmail == nil {
                self.kakaoRequestAgreement()
                return
            }
            
//            self.textField.text = contentText
            print(#fileID, #function, #line, "- 유저 정보: \(contentText)")
        }
    }
    
    /// 추가 항목 동의받기
    func kakaoRequestAgreement() {
        // 추가 항목 동의 받기(사용자가 동의하지않은 항목에 대한 추가 동의 요청
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print(error)
            }
            else {
                guard let user = user else { return }
                var scopes = [String]()
                if (user.kakaoAccount?.profileNeedsAgreement == true) { scopes.append("profile") }
                if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
                if (user.kakaoAccount?.birthdayNeedsAgreement == true) { scopes.append("birthday") }
                if (user.kakaoAccount?.birthyearNeedsAgreement == true) { scopes.append("birthyear") }
                if (user.kakaoAccount?.genderNeedsAgreement == true) { scopes.append("gender") }
                if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) { scopes.append("phone_number") }
                if (user.kakaoAccount?.ageRangeNeedsAgreement == true) { scopes.append("age_range") }
                if (user.kakaoAccount?.ciNeedsAgreement == true) { scopes.append("account_ci") }

                if scopes.count > 0 {
                    print("사용자에게 추가 동의를 받아야 합니다.")

                    // OpenID Connect 사용 시
                    // scope 목록에 "openid" 문자열을 추가하고 요청해야 함
                    // 해당 문자열을 포함하지 않은 경우, ID 토큰이 재발급되지 않음
                    // scopes.append("openid")

                    //scope 목록을 전달하여 카카오 로그인 요청
                    UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (_, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            UserApi.shared.me() { (user, error) in
                                if let error = error {
                                    print(error)
                                }
                                else {
                                    print("me() success.")
                                    guard let user = user else { return }

                                    //do something
                                    let userName = user.kakaoAccount?.name
                                    let userEmail = user.kakaoAccount?.email
                                    let userGender = user.kakaoAccount?.gender
                                    let userProfile = user.kakaoAccount?.profile?.profileImageUrl
                                    let userBirthYear = user.kakaoAccount?.birthyear

                                    let contentText =
                                    "user name : \(userName)\n userEmail : \(userEmail)\n userGender : \(userGender), userBirthYear : \(userBirthYear)\n userProfile : \(userProfile)"

//                                    self.textField.text = contentText
                                    print(#fileID, #function, #line, "- 유저정보2: \(contentText)")
                                }
                            }
                        }
                    }
                }
                else {
                    print("사용자의 추가 동의가 필요하지 않습니다.")
                }
            }
        }
    }
}

//
//  ViewModel.swift
//  PersonalSchedule
//
//  Created by seohyeon park on 2023/01/12.
//

import Foundation
import Combine
import KakaoSDKUser
import FBSDKLoginKit

class ViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var schedule = Dummy()

    func hasLoggedInHistory() -> Bool {
        if UserDefaults.standard.object(forKey: "userID") != nil {
            return true
        } else {
            return false
        }
    }

    func handleFacebookLogin() {
        LoginManager().logIn(permissions: ["public_profile", "email"], from: nil) { (loginManagerLoginResult, error) in
            if let error = error {
                print("❌ \(error)")
                return
            }
            
            guard let result = loginManagerLoginResult else {
                print("❌ LogIn failed. No results.")
                return
            }
            
            guard let token = result.token else {
                print("❌ User canceled or no token.")
                return
            }

            self.setUserDefaults(token.tokenString)
            self.isLoggedIn = true
        }
    }

    @MainActor
    func handleKakaoLogin() {
        Task {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                isLoggedIn = await handleLoginWithKakaoTalkApp()
            } else {
                isLoggedIn = await handleLoginWithKakaoAccount()
            }

            let userID = await getKakaoUserID()
            
            if isLoggedIn && userID  != "-1" {
                setUserDefaults(userID)
            }
        }
    }

    func kakaoLogout() async -> Bool {
        let isLoggedOut = await Task {
            return await handleKakaoLogout()
        }.value

        return isLoggedOut
    }

    @MainActor
    private func handleLoginWithKakaoTalkApp() async -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        })
    }
    
    @MainActor
    private func handleLoginWithKakaoAccount() async -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        })
        
    }

    @MainActor
    private func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        })
    }
    
    private func getKakaoUserID() async -> String {
        await withCheckedContinuation({ continuation in
            UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: "-1")
                }
                else {
                    continuation.resume(returning: String(accessTokenInfo?.id ?? -1))
                }
            }
        })
    }

    private func setUserDefaults(_ value: Any?) {
        UserDefaults.standard.set(value, forKey: "userID")
    }
}

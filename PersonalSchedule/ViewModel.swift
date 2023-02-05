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
    @Published var isLogin = false
    @Published var showingAlert = false
    @Published var schedule = Dummy()

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
            
            guard result.token != nil else {
                print("❌ User canceled or no token.")
                return
            }
 
            self.isLogin = true
        }
    }

    @MainActor
    func handleKakaoLogin() {
        Task {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                isLogin = await handleLoginWithKakaoTalkApp()
            } else {
                isLogin = await handleLoginWithKakaoAccount()
            }
            
            if isLogin {
                showingAlert = false
            } else {
                showingAlert = true
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
}

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
    @Published var schedules = [Schedule]()

    func setSchedules() {
        schedules = [Schedule]()
        FirebaseManager.shared.fetch { data in
            data.forEach { schedule in
                let mappingSchedule = Schedule(
                    id: schedule["id"] as? String ?? UUID().description,
                    title: schedule["title"] as? String ?? "",
                    date: schedule["date"] as? Date ?? Date(),
                    body: schedule["body"] as? String ?? "",
                    emoji: schedule["emoji"] as? String ?? ""
                )
                self.schedules.append(mappingSchedule)
            }
        }
    }
    
    func add(schedule: Schedule) {
        FirebaseManager.shared.save(schedule)
    }
    
    func delete(index: Int) {
        let id = schedules.remove(at: index).id
        FirebaseManager.shared.delete(id: id)
    }

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

            self.setUserDefaults(token.userID)
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
            
            if isLoggedIn && userID != "-1" {
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

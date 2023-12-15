//
//  observed_objects.swift
//  wchs
//
//  Created by Paul Crews on 11/4/23.
//

import Foundation
import GoogleSignIn

class UserModel:ObservableObject{
    
    enum SignInState{
        case signedIn
        case signedOut
    }
    
    @Published var presenting = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
    @Published var current_user : GWUser = GWUser(
        user_id: "",
        scopes: [],
        access_token: "",
        refresh_token: "",
        id_token: "",
        email: "",
        name: "",
        given_name: "",
        family_name: "",
        has_image: false, 
        img_dimensions: URL(string: "https://placehold.co/600x400")!,
        is_signed_in: false,
        is_admin: false
    )

    func createUser(user: GIDGoogleUser){
        current_user.email = "\(user.profile?.email ?? "")"
        current_user.access_token = user.accessToken.tokenString
        current_user.family_name = user.profile?.familyName ?? ""
        current_user.given_name = user.profile?.givenName ?? ""
        current_user.has_image = user.profile?.hasImage ?? false
        current_user.id = user.userID ?? ""
        current_user.id_token = "\(String(describing: user.idToken))"
        current_user.img_dimensions = user.profile?.imageURL(withDimension: 900) ?? URL(string: "")!
        current_user.name = user.profile?.name ?? ""
        current_user.refresh_token = "\(user.refreshToken)"
        current_user.scopes = user.grantedScopes ?? []
        current_user.user_id = user.accessToken.tokenString
        current_user.is_signed_in = true
        current_user.is_admin = true
    }
    
    func handleSignIn(){
        let presenting = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
        func addScopes(_ scopes: [String], presentingWindow: Any!) {
            GIDSignIn.sharedInstance.signIn(withPresenting: presenting!) { [self]
                signInResult, error in
                guard let result = signInResult else {
                    print("Error \(String(describing: error?.localizedDescription))")
                    return
                }
                result.user.addScopes(granted_scopes, presenting: presenting!)
                if let user = signInResult?.user {
                    self.createUser(user: user)
                }
            }
            return
        }
    }
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        current_user.is_signed_in = false
        current_user = GWUser(user_id: "", scopes: [], access_token: "", refresh_token: "", id_token: "", email: "", name: "", given_name: "", family_name: "", has_image: false, img_dimensions: URL(string:"https://placehold.co/600x400")!, is_signed_in: false, is_admin: false)
    }
//    func addScopes(_ scopes: [String], presenting presentingViewController: UIViewController) async throws -> GIDSignInResult {
//        
//        
//    }
}

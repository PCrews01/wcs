//
//  wchsApp.swift
//  wchs
//
//  Created by Paul Crews on 11/2/23.
//

import SwiftUI
import SwiftData
import GoogleSignIn

@main
 struct wchsApp: App {
    @State var vc : UIViewController = UIViewController()
    @State var user_model = UserModel()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user_model)
                .onAppear{
                    GIDSignIn.sharedInstance.restorePreviousSignIn{
                        user, error in
                        if let user = user {
                            user_model.createUser(user: user)
                        }
                    }
                }
                .onOpenURL(perform: { url in
                    
                    GIDSignIn.sharedInstance.handle(url)
                })
                .tint(Color("PrimaryColor"))
        }
        .modelContainer(sharedModelContainer)
    }
}

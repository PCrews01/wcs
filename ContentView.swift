//
//  ContentView.swift
//  wchs
//
//  Created by Paul Crews on 11/2/23.
//

import SwiftUI
import SwiftData
import GoogleSignInSwift
import GoogleSignIn

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @EnvironmentObject var user_model : UserModel
    @State var nav_open : Bool = true

    var body: some View {
        NavigationSplitView {
            List {
                AsyncImage(url: user_model.current_user.img_dimensions){
                    img in
                    if let im = img.image {
                        im.resizable()
                    }
                }.frame(width: 40, height: 40)
                if user_model.current_user.is_signed_in {
                    ForEach(scopes.filter( user_model.current_user.is_admin ? {$0.title != "" } : { $0.need_admin == false }), id: \.self) { item in
                        NavigationLink {
                            if item.title == "Home" {
                                HomeView()
                            } else if item.title == "Contacts" {
                                ContactsView()
                            } else if item.title == "Drive" {
                                DriveView()
                            } else if item.title == "Helpdesk" {
                                HelpdeskView()
                            } else if item.title == "Forms" {
                                FormsView()
                            } else if item.title == "Docs" {
                                DocsView()
                            } else if item.title == "Sheets"{
                                SheetsView()
                            } else if item.title == "Admin"{
                                AdminView()
                            } else {
                                Text(item.title)
                            }
                        } label: {
                            Text("\(item.title)")
                        }
                        
                    }
                    .onDelete(perform: deleteItems)
                } else {
                    
                Button {
                    handleSignInButton()
                } label: {
                    Text("Sign me in")
                        .padding()
                        .background(Color("PrimaryColor"))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(width: 150, height: 10, alignment: .center)

                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
                if user_model.current_user.is_admin{
#if os(iOS)
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        EditButton()
//                    }
#endif
//                    ToolbarItem {
//                        Button(action: addItem) {
//                            Label("Add Item", systemImage: "plus")
//                        }
//                    }
                    ToolbarItem {
                        Button(action: user_model.signOut) {
                            Text("Sign Out")
                        }
                    }
                }
            }
        } detail: {
            if (user_model.current_user.email.count > 1) {
                HomeView()
            } else {
                VStack{
                    Image("logo_wide_green")
                        .resizable()
                        .frame(width: 400, height: 300, alignment: .center)
                    Button {
                        handleSignInButton()
                    } label: {
                        Text("Sign me in")
                            .padding()
                            .background(Color("PrimaryColor"))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 150, height: 10, alignment: .center)
            }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    func handleSignInButton(){
        let presenting = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
        
        GIDSignIn.sharedInstance.currentUser?.addScopes(user_model.current_user.scopes, presenting: presenting!){ res,err in
            if let error = err {
                print("error \(error)")
                return
            }
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting!) {
            signInResult, error in
            guard signInResult != nil else {
                print("Error \(error!.localizedDescription.lowercased())")
                return
            }
            if let user = signInResult?.user {
                user_model.createUser(user: user)
                
            }
        }
    }
    func getGoogle(){
        
        let GURL = "https://admin.googleapis.com/admin/directory/v1/users?customer=\(google_customer)&domain=\(google_domain)&key=\(google_key)"
        
        var request_url = URLRequest(url: URL(string: GURL)!)
        
        request_url.addValue("Bearer ya29.a0AfB_byDSEcEqKl5lfDfg4cpYgS4DUQLoo7m10O5s5kVxsPiTTi18vTawLLMpt7mOiifpyH_TICMKYWj3JsTzlxA9yOQob6JystvaD6rUTTpMR50qapDo4d47pLfnofNB3G_SMpz4mP4zNyYaG_VDxxJ1j8Mtr", forHTTPHeaderField: "Authorization")
        request_url.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request_url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            //            Check if there was data received
            guard data != nil else {
                //                If there was no data returned stop the code
                print("No data received")
                return
            }
        }
        task.resume()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

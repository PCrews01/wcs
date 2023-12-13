//
//  FormsView.swift
//  wchs
//
//  Created by Paul Crews on 11/4/23.
//

import SwiftUI

struct FormsView: View {
    @EnvironmentObject var user_model : UserModel
    @State var show_list                :   Bool    =   false
    @State var forms : [GWForm] = []
    var body: some View {
        PageHeader(title: "Forms")
        HStack{
            Spacer()
            Toggle(show_list ? "Grid View" : "List View" ,isOn: $show_list)
                .animation(.bouncy, value: show_list)
        }
        if forms.count < 1 {
            Text("Helpdesk")
                .onAppear {
                    getForms()
                }
        } else {
            ScrollView{
                if !show_list {
                    LazyVGrid(columns: getGridColumns(column: 3)) {
                        ForEach(forms, id:\.id){
                            form in
                            NavigationLink {
                                FormView(sheet_id: form.sheet_id)
                            } label: {
                                VStack{
                                    Image(systemName: "doc.text.image")
                                        .resizable()
                                        .frame(width: 75, height: 75)
                                    Text(form.name)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .background(Color("PrimaryColor"))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(height: 300, alignment: .center)
                                .padding(.bottom, 15)
                            }
                        }
                    }
                } else {
                    VStack{
                        ForEach(forms, id:\.id){ form in
                            NavigationLink {
                                FormView(sheet_id: form.sheet_id)
                            } label: {
                                HStack{
                                    Text(form.name)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                .padding()
                                .foregroundStyle(.white)
                                .background(Color.purple)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getForms(){
        
        let url = "https://www.googleapis.com/drive/v3/files?corpus=user&q=mimeType%3D%22application%2Fvnd.google-apps.form%22"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request){
            data, response, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received ")
                return
            }
            
            do {
                if let json_object = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    let returned_files = json_object.filter({$0.key == "files"})
                    
                    for file in returned_files{
                            if let c = file.value as? [[String:String]]{
                                for x in c {
                                    let new_file : GWForm = GWForm(id: x["id"] ?? "No ID", kind: x["kind"] ?? "No Kind", mime_type: x["mimeType"] ?? "No Mime", name: x["name"] ?? "No Name", sheet_id: x["id"] ?? "x")
                                    
                                    withAnimation(.bouncy){
                                        forms.append(new_file)
                                    }
                                }
                            
                        }
                    }
                }
            } catch {
                print("Error doing")
            }
        }
        task.resume()
    }
}

#Preview {
    FormsView()
}

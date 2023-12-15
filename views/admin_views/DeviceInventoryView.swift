//
//  DeviceTotalsView.swift
//  wchs
//
//  Created by Paul Crews on 11/22/23.
//

import SwiftUI
import Charts

struct DeviceInventoryView: View {
    @EnvironmentObject var user_model : UserModel
    @State var device : String
    @State var device_list : [InventoryDevice] = []
    @State var show_broken_devices : Bool = false
    @State var device_orientation : UIDeviceOrientation = UIDeviceOrientation.unknown
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                VStack{
                    PageHeader(title: "Inventory details for WCHS \(device)")
                        .onAppear{
                            withAnimation(.bouncy){
                                getInventory(device: device)
                            }
                        }
                }
                if device_list.count == 0{
                    ProgressView {
                        Text("Loading...")
                    }
                } else {
                    VStack{
                        ScrollView(.horizontal){
                            HStack{
                                VStack{
                                    GroupBox("\(device) by Model: \(device_list.dropFirst().count) total."){
                                        Chart(device_list.dropFirst(), id:\.id) { xc in
                                            let device_models = device_list.filter( device == "Printers" ? {$0.vendor == xc.vendor} : {$0.model == xc.model}).count
                                            BarMark(x: .value("Model",device == "Printers" ? xc.vendor : xc.model), y: .value("List", device_list.dropFirst().count))
                                                .annotation(position: .top){
                                                    Text("\(device_models)")
                                                        .font(.callout)
                                                        .fontWeight(.bold)
                                                        .fontWidth(.expanded)
                                                        .padding(.horizontal)
                                                        .background(Color.white)
                                                        .frame(height: 50)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                }
                                                .foregroundStyle(by: .value("Floors", "\(device == "Printers" ? xc.vendor : xc.model): \(device_models)"))
                                        }.font(.caption)
                                            .padding()
                                            .chartYAxis(.hidden)
                                        
                                    }
                                }.frame(width:( geo.size.width - 50), alignment: .center)
                            }
                            .padding()
                            .frame(height: geo.size.height / 3, alignment: .center)
                            HStack{
                                Spacer()
                                Button {
                                    withAnimation(.bouncy){
                                        show_broken_devices.toggle()
                                    }
                                } label: {
                                    Text("\(show_broken_devices ? "Hide" : "Show") broken devices?")
                                }.padding()
                            }
                        }
                        VStack{
                            Table(of: InventoryDevice.self) {
                                TableColumn("Vendor", value: \.vendor)
                                TableColumn("Model", value: \.model)
                                TableColumn("Serial", value: \.serial)
                                TableColumn("Tag", value: \.tag)
                                TableColumn("User", value: \.user)
                                TableColumn("Status", value: \.status)
                                TableColumn("Location", value: \.location)
                                TableColumn("Other", value: \.other!)
                            } rows: {
                                ForEach(device_list.dropFirst(), id:\.id){
                                    dev in
                                    TableRow(dev)
                                        
                                }
                            }
                            
                        }.frame(height: geo.size.height / 3, alignment: .center)
                    }
                }
            }.onRotate { newOrientation in
                withAnimation(.bouncy){
                    device_orientation = newOrientation
                }
            }
        }
    }
    func getInventory(device:String?){
        let sheet_id = data_set_id
        let sheet_range = "\(device!)!A1:H"
        let sheet_update_url = "https://sheets.googleapis.com/v4/spreadsheets/\(sheet_id)/values/\(sheet_range)"
        guard let s_id = URL(string: sheet_update_url) else {
            return
        }
        
        var request = URLRequest(url: s_id)
        request.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let request_session = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            if let error = error {
                print("There was an error getting Inventory \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data returned from inventory.")
                return
            }
            
            do{
                if let json_output = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    if let values = json_output["values"] as? [[String]]{
                        
                        let device_vendor = values.first!.firstIndex(of: "Vendor")
                        let device_model = values.first!.firstIndex(of: "Model")
                        let device_serial = values.first!.firstIndex(of: "Serial")
                        let device_tag = values.first!.firstIndex(of: "Tag")
                        let device_user = values.first!.firstIndex(of: "User")
                        let device_status = values.first!.firstIndex(of: "Status")
                        let device_location = values.first!.firstIndex(of: "Location")
                        let device_other = values.first!.firstIndex(of: "Other")
                        
                        for value in values {
                            if let device_info = InventoryDevice(
                                vendor:     value[device_vendor!],
                                model:      value[device_model!],
                                serial:     value[device_serial!],
                                tag:        value[device_tag!],
                                user:       value[device_user!],
                                status:     value[device_status!],
                                location:   value[device_location!],
                                other:      value[device_other!]
                            ) as? InventoryDevice {
                                if !device_list.contains(device_info){
                                    device_list.append(device_info)
                                }
                            } else {
                                print("Error forming device")
                                return
                            }
                        }
                    } else {
                        print("No values \(json_output["values"] ?? "")")
                    }
                } else {
                    print("No json_output.")
                }
                
            }catch(let err){
                print("There was an error doing \(err.localizedDescription)")
            }
        }
        request_session.resume()
    }
}

#Preview {
    DeviceInventoryView(device: "Form")
}

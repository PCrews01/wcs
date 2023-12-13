//
//  HelpdeskView.swift
//  wchs
//
//  Created by Paul Crews on 11/5/23.
//

import SwiftUI

struct HelpdeskView: View {
    @State var ticket_container : [AteraTicket] = []
    @State var show_new_ticket_sheet : Bool = false
    @State var show_ticket_details : String = ""
    @State var new_ticket : String = ""
    @State var new_ticket_issue : String = ""
    
    var body: some View {
        VStack{
            PageHeader(title: "Helpdesk")
            if ticket_container.count < 1 {
                Text("Helpdesk")
                    .onAppear {
                        getTickets()
                    }
            } else {
                HStack{
                    Spacer()
                    Button(action: {
                        show_new_ticket_sheet = true
                    }, label: {
                        Text("New Ticket")
                    })
                }
                List{
                    Section("Tickets"){
                        ForEach(ticket_container, id:\.TicketID){
                            ticket in
                            VStack{
                                HStack{
                                    Text("\(ticket.TicketTitle)")
                                        .font(show_ticket_details == "\(ticket.TicketID)" ? .title : .body)
                                        .fontWeight(show_ticket_details == "\(ticket.TicketID)" ? .bold : .regular)
                                    Spacer()
                                    if ticket.TicketStatus == "Open"{
                                        Image(systemName: "envelope.open.badge.clock")
                                    } else {
                                        Image(systemName: "hand.thumbsup.circle.fill")
                                    }
                                }
                                .onTapGesture {
                                    withAnimation(.bouncy){
                                        if show_ticket_details == "\(ticket.TicketID)"{
                                            show_ticket_details = ""
                                        } else {
                                            show_ticket_details = "\(ticket.TicketID)"
                                        }
                                    }
                                }
                                
                                if show_ticket_details == "\(ticket.TicketID )"{
                                    VStack{
                                        HStack{
                                            VStack(alignment: .leading){
                                                Text("\(ticket.TicketID)")
                                                Text("\(ticket.TicketCreatedDate)")
                                                Text("\(ticket.TicketImpact)")
                                                Text("\(ticket.TicketPriority)")
                                                Text("\(ticket.TicketSource)")
                                                Text("\(ticket.TicketStatus)")
                                                Text("\(ticket.TicketType)")
                                            }
                                            Spacer()
                                            VStack(alignment: .trailing){
                                                HStack{
                                                    Text("\(ticket.EndUserFirstName)")
                                                    Text("\(ticket.EndUserLastName)")
                                                }.font(.title).fontWeight(.bold).padding()
                                                Text("\(ticket.EndUserEmail)")
                                                
                                            }
                                        }
                                        
                                        Text(ticket.first_comment)
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.leading)
                                            .padding()
                                            .background(Color("PrimaryColor"))
                                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                            .padding(.bottom)
                                        Text(ticket.last_technician_comment ?? "No reply from technician")
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.leading)
                                            .padding()
                                            .background(Color("PrimaryColor").opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                            .padding(.bottom)
                                        Text(ticket.last_end_user_comment)
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.leading)
                                            .padding()
                                            .background(.blue.opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                            .padding(.bottom)
                                    }
                                }
                            }
                        }
                    }
                    Section("Mosyle Devices"){
                        
                    }
                }
                
            }
        }.sheet(isPresented: $show_new_ticket_sheet, content: {
            Form(content: {
                VStack{
                    TextField("Ticket Title", text: $new_ticket)
                    TextField("Issue", text: $new_ticket_issue)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Text("Create Ticket")
                    })
                }
            })
        })
    }
    
    private func getTickets(){
        getMosyleCredentials()
        let url = "https://app.atera.com/api/v3/tickets"
        
        var ticket_request = URLRequest(url: URL(string: url)!)
        ticket_request.setValue(atera_key, forHTTPHeaderField: "X-API-KEY")
        ticket_request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let ticket_session = URLSession.shared
        
        let get_ticket_task = ticket_session.dataTask(with: ticket_request){
            ticket_data, ticket_response, error in
            
            if let error = error {
                print("There was an error getting tickets. \(error.localizedDescription)")
                return
            }
            
            guard let ticket_data = ticket_data else {
                print("No tickets returned")
                return
            }
            
            do {
                if let ticket_json_response = try JSONSerialization.jsonObject(with: ticket_data, options: []) as? [String:Any] {
                    if let ticket_items = ticket_json_response["items"] as? [[String:Any]] {
                        //                        let ticket = ticket_items.first
                        
                        for ticket in ticket_items{
                            var new_ticket : AteraTicket = AteraTicket(TicketID: 0, TicketTitle: "", TicketNumber: "", TicketPriority: "", TicketImpact: "", TicketStatus: "", TicketSource: "", TicketType: "", EndUserID: 0, EndUserEmail: "", EndUserFirstName: "", EndUserLastName: "", EndUserPhone: "", TicketResolvedDate: "", TicketCreatedDate: "", first_comment: "", last_end_user_comment: "", last_technician_comment: "")
                            
                            new_ticket.EndUserEmail = ticket["EndUserEmail"] as? String ?? ""
                            new_ticket.EndUserFirstName = ticket["EndUserFirstName"] as? String ?? ""
                            new_ticket.EndUserID = ticket["EndUserID"] as? Int ?? 0
                            new_ticket.EndUserLastName = ticket["EndUserLastName"] as? String ?? ""
                            new_ticket.EndUserPhone = ticket["EndUserPhone"] as? String ?? ""
                            new_ticket.TicketCreatedDate = ticket["TicketCreatedDate"] as? String ?? ""
                            new_ticket.TicketID = ticket["TicketID"] as? Int ?? 0
                            new_ticket.TicketImpact = ticket["TicketImpact"] as? String ?? ""
                            new_ticket.TicketNumber = ticket["TicketNumber"] as? String ?? ""
                            new_ticket.TicketPriority = ticket["TicketPriority"] as? String ?? ""
                            new_ticket.TicketResolvedDate = ticket["TicketResolveDate"] as? String ?? ""
                            new_ticket.TicketSource = ticket["TicketSource"] as? String ?? ""
                            new_ticket.TicketStatus = ticket["TicketStatus"] as? String ?? ""
                            new_ticket.TicketTitle = ticket["TicketTitle"] as? String ?? ""
                            new_ticket.TicketType = ticket["TicketType"] as? String ?? ""
                            new_ticket.first_comment = ticket["FirstComment"] as? String ?? ""
                            new_ticket.last_technician_comment = ticket["LastTechnicianComment"] as? String ?? ""
                            new_ticket.last_end_user_comment = ticket["LastEndUserComment"] as? String ?? ""
                            
                            withAnimation(.bouncy) {
                                ticket_container.append(new_ticket)
                            }
                        }
                    }
                }
            } catch(let e){
                print("There's been an error with atera \(e.localizedDescription)")
            }
        }
        get_ticket_task.resume()
    }
    
    private func getMosyleCredentials(){
        let url = URL(string: "https://managerapi.mosyle.com/v2/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Define the request body
        let token : [String:String] = [
            "accessToken": mosyle_key,
            "email": "pcrews@thewcs.org",
            "password": "Austin3:16"
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: token) {
            request.httpBody = jsonData
        }

        // Create a URLSession task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                // Handle the response data here
                if let responseString = try? JSONSerialization.jsonObject(with:  data) as? [String:Any] {
                    print("Response: \(responseString)")
                    if(responseString["UserID"] != nil){
                        getMosyleDevices(tokens: responseString["UserID"] as! String)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func getMosyleDevices(tokens: String){
        let url = "https://managerapi.mosyle.com/v2/listdevices"
        
        var device_request = URLRequest(url: URL(string: url)!)
        
        device_request.addValue("JWT \(mosyle_key)", forHTTPHeaderField: "Authorization")
        device_request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        device_request.httpMethod = "POST"
        
        let token : [String:String] = [
            "accessToken": mosyle_key
        ]
        if let json_token = try? JSONSerialization.data(withJSONObject: token){
            device_request.httpBody = json_token
        }
        let device_session = URLSession.shared
        
        let device_task = device_session.dataTask(with: device_request){
            device_data,device_p, error  in
            
            guard let device_data = device_data else {
                print("device error")
                return
            }
            print("Device \(device_data)")
            do{
                if try JSONSerialization.jsonObject(with: device_data, options: []) is [String:Any] {
                    
                }
            } catch(let e){
                print("Error with devices \(e.localizedDescription)")
            }
            
        }
        device_task.resume()
    }
}

#Preview {
    HelpdeskView()
}

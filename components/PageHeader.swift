//
//  PageHeader.swift
//  wchs
//
//  Created by Paul Crews on 11/5/23.
//

import SwiftUI

struct PageHeader: View {
    @State var title : String
    @State var device_orientation : UIDeviceOrientation = UIDeviceOrientation.unknown
    var body: some View {
        VStack{
            Image("logo_wide_green")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: device_orientation.isLandscape ? 50 : 100)
                .padding()
                .ignoresSafeArea(.keyboard)
            Text(title)
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(Color("PrimaryColor"))
        }.onRotate { newOrientation in
            device_orientation = newOrientation
        }
    }
}

#Preview {
    PageHeader(title: "Test")
}

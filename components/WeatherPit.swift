//
//  WaetherPit.swift
//  wchs
//
//  Created by Paul Crews on 11/12/23.
//

import SwiftUI

struct WeatherPit: View {
    @State var weather_forecast : [WeatherInfo] = []
    var body: some View {
        VStack{
            if weather_forecast.count < 1 {
                Text("Weather")
                    .onAppear{
                        getWeather()
                    }
            }
            
            if weather_forecast.count > 0 {
                ZStack{
                    Image(getWeatherImage(temp: weather_forecast.first!.temperature)).resizable()
                        .aspectRatio(contentMode: .fill)
                    Color("PrimaryColor")
                        .opacity(0.25)
                    HStack{
//                        adjust the spacer based on the images negative space
                        if getWeatherImage(temp: weather_forecast.first!.temperature) == "chilly_day" || getWeatherImage(temp: weather_forecast.first!.temperature) == "cold_day" {
                            Spacer()
                        }
                        VStack{
                            Text("Today is").font(.caption)
                                .padding(.trailing, 25)
                            Text("\(weather_forecast.first!.date)").fontWeight(.bold)
                            Text("it is").font(.caption)
                            Text("\(weather_forecast.first!.temperature)℉")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                            Text("...but it feels like")
                                .font(.caption)
                            Text("\(weather_forecast.first!.feels_like)℉")
                                .fontWeight(.bold)
                                .padding(.leading, 25)
                        }.blendMode(.hardLight)
                            .shadow(radius: 15)
                        if getWeatherImage(temp: weather_forecast.first!.temperature) != "chilly_day" && getWeatherImage(temp: weather_forecast.first!.temperature) != "cold_day"{
                            Text("Chilly \(getWeatherImage(temp: weather_forecast.first!.temperature))")
                            Spacer()
                        }
                    }
                    .frame(width: 600, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    func getWeatherImage(temp:String) -> String{
        
        let temp_number : Double = Double(temp) ?? 0
        
        
        if temp_number < 20 {
            return "windy_day"
            
        }
        if temp_number > 20 && temp_number < 40{
            return "cold_day"
        }
        if temp_number > 40 && temp_number < 60 {
            return "chilly_day"
        }
        if temp_number > 60 && temp_number < 80 {
            return "relaxing"
        }
        if temp_number > 80 && temp_number < 100 {
            return "beach_day"
        }
        return "chilly_day"
    }
    
    func getWeather(){
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(weather_key)&q=11206&days=3&aqi=no&alerts=no")
        let weather_request = URLRequest(url: url!)
        let weather_session = URLSession.shared
        
        
        let weather_task = weather_session.dataTask(with: weather_request){
            weather_data, weather_response, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            }
            
            guard let weather_data = weather_data else {
                print("No data received")
                return
            }
            do {
                if let weather_json = try JSONSerialization.jsonObject(with: weather_data
                                                                       , options: []) as? [String:Any] {
                    
                        if let forecast_current = weather_json["current"] as? [String:Any]{
                            let weather_condition = forecast_current["condition"] as? [String:Any]
                            let weather_location = weather_json["location"] as? [String:Any]
                            let date_formatter = DateFormatter()
                            
                            date_formatter.dateFormat = "yyyy-MM-dd HH:mm"
//                            date_formatter.dateStyle
                            let local_time = weather_location?["localtime"] as? String ?? ""
                            let right_now = date_formatter.date(from: local_time)
                            let date_style = DateFormatter()
                                date_style.dateFormat = "MMMM dd, yyyy"
                                
                            let out_date = date_style.string(from: right_now ?? Date.now)
                            
                            
                            let icon = weather_condition?["icon"]
                            let weather_pod : WeatherInfo = WeatherInfo(
                                humidity: "\(forecast_current["humidity"] ?? "x")",
                                feels_like: "\(forecast_current["feelslike_f"] ?? "x")",
                                temperature: "\(forecast_current["temp_f"] ?? "x")",
                                wind_dir: "\(forecast_current["wind_dir"] ?? "x")",
                                cloud: "\(forecast_current["cloud"] ?? "x")",
                                wind: "\(forecast_current["gust_mph"] ?? "x")",
                                icon: icon != nil ? icon as! String : "chilly_day" ,
                                date: out_date
                            )
                            withAnimation(.bouncy){
                                weather_forecast.append(weather_pod)
                            }
                            
                        } else {
                            print("This is forecast day")
                        }
                }
            } catch (let error){
                print("There's been an error with the JSON \(error.localizedDescription)")
            }
        }
        weather_task.resume()
    }
}

#Preview {
    WeatherPit()
}

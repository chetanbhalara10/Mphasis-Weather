//
//  WeatherView.swift
//  Mphasis-Weather
//
//  Created by CHB on 8/12/24.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    
    //@StateObject used to get
    @StateObject var location = LocationDataManager()
    @StateObject var weatherVM = WeatherViewModel(weatherDataRepository: DependencyInjection.getWeatherDataRepository(), preferenceStore: DependencyInjection.getPreferenceStore(), metricsManager: DependencyInjection.getMetricsManager())
    
    //Used to add View to parent view and move back
    var presentingVC: UIViewController?
    
    //Binding with interface
    @State private var cityName = ""
    @State private var isHidden = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.presentingVC?.presentedViewController?.dismiss(animated: true)
            }) {
                Group {
                    Spacer().frame(width: 0, height: 36.0, alignment: .topLeading)
                    HStack {
                        
                        Text("Back")
                            .bold()
                            .font(.system(size: 17.0))
                            .padding(.leading, 4.0)
                    }
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 60, height: 0)
                        .padding(.top, 6.0)
                }
            }
            Section {
                TextField("Please enter city name", text: $cityName)
                    .textFieldStyle(OvalTextFieldStyle())
                    .onTapGesture {
                        cityName = ""
                    }
            } footer: {
                Text(weatherVM.cityNameErrorMessage!)
                  .foregroundColor(.red)
            }
            
            HStack {
                Button(action: {
                    weatherVM.getWeatherData(city: cityName)
                    isHidden = false
                    if (weatherVM.cityNameErrorMessage != "")
                    {
                        isHidden = true
                        weatherVM.weatherData?.resetData()
                        //weatherVM.cityNameErrorMessage ?? "Please enter valide US city"
                    }
                }) {
                    Group {
                        HStack {
                            
                            Text("Search")
                                .bold()
                                .font(.system(size: 17.0))
                                .padding(.leading, 4.0)
                        }
                    }
                }
                
                Button(action: {
                    // Request for location service
                    switch location.authorizationStatus {
                    case .notDetermined:
                        RequestLocationView()
                    case .authorizedAlways, .authorizedWhenInUse:
                        
                        cityName = location.currentPlacemark?.locality ?? "City not found"
                        if cityName != "City not found" {
                            isHidden = false
                            weatherVM.getWeatherData(city: cityName)
                        } else {
                            isHidden = true
                        }
                        
                    default:
                        cityName = "City not found"
                        isHidden = true
                    }
                    
                }) {
                    Group {
                        HStack {
                            
                            Text("Current Location")
                                .bold()
                                .font(.system(size: 17.0))
                                .padding(.leading, 50.0)
                        }
                    }
                }
            }
            
            Group {
                VStack(alignment :.leading) {
                    VStack {
                        PairView(
                            leftText: "Current Temp:",
                            rightText: String(weatherVM.weatherData?.temp ?? 0.0)
                        ).opacity(isHidden ? 0 : 1)
                        
                        PairView(
                            leftText: "Min Temp:",
                            rightText: String(weatherVM.weatherData?.temp_min ?? 0.0)
                        ).opacity(isHidden ? 0 : 1)
                        
                        PairView(
                            leftText: "Max Temp:",
                            rightText: String(weatherVM.weatherData?.temp_max ?? 0.0)
                        ).opacity(isHidden ? 0 : 1)
                        
                        PairView(
                            leftText: "Weather:",
                            rightText: String(weatherVM.weatherData?.description ?? "")
                        ).opacity(isHidden ? 0 : 1)
                        
                        PairView(
                            leftText: "Humidity:",
                            rightText: String(weatherVM.weatherData?.humidity ?? 0)
                        ).opacity(isHidden ? 0 : 1)
                        
                        PairView(
                            leftText: "Visibility:",
                            rightText: String(weatherVM.weatherData?.visibility ?? 0)
                        ).opacity(isHidden ? 0 : 1)
                        
                        PairView(
                            leftText: "Wind Speed:",
                            rightText: String(weatherVM.weatherData?.speed ?? 0.0)
                        ).opacity(isHidden ? 0 : 1)
                        
                        PairView(
                            leftText: "Sunrise:",
                            rightText: String(weatherVM.weatherData?.sunrise ?? "")
                        ).opacity(isHidden ? 0 : 1)
                        
                        PairView(
                            leftText: "Sunset:",
                            rightText: String(weatherVM.weatherData?.sunset ?? "")
                        ).opacity(isHidden ? 0 : 1)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            // This should be the last, put everything to the top
            Spacer()
            
        }
        .environmentObject(location)
        .environmentObject(weatherVM)
        .onAppear(){
            isHidden = true
            if (weatherVM.getRecentCity() != "") {
                cityName = weatherVM.getRecentCity()
                
                weatherVM.getWeatherData(city: cityName)
                isHidden = false
                if (weatherVM.cityNameErrorMessage != "")
                {
                    isHidden = true
                    cityName = weatherVM.cityNameErrorMessage ?? "Please enter valid US city"
                }
            }
        }
    }
}

struct RequestLocationView: View {
    @EnvironmentObject var location: LocationDataManager
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                location.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("We need your permission to track you.")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PairView: View {
    let leftText: String
    let rightText: String
    
    var body: some View {
        HStack {
            Text(leftText)
            Spacer()
            Text(rightText)
        }
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color(UIColor.lightGray))
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

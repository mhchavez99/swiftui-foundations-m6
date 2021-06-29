//
//  OnboardingView.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/28/21.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var tabSelection = 0
    @EnvironmentObject var model:ContentModel
    private let blue = Color(red: 0.0/255.0, green: 130.0/255.0, blue: 167.0/255.0)
    private let turquoise = Color(red: 55.0/255.0, green: 197.0/255.0, blue: 192.0/255.0)
    
    var body: some View {
        
        VStack{
            //tab view
            
            TabView(selection: $tabSelection) {
                //first tab
                VStack(spacing: 20){
                    Image("city2")
                        .resizable()
                        .scaledToFit()
                    Text("Welcome to City Sights!")
                        .bold()
                        .font(.title)
                    Text("City Sights helps you find the best of the city!")
                       
                }.tag(0)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

                //second tab
                VStack(spacing: 20){
                    Image("city1")
                        .resizable()
                        .scaledToFit()
                    Text("Ready to discover your city?")
                        .bold()
                        .font(.title)
                    Text("We'll show you the best restaurants, venues, and more based on you location.")
                        
                    
                }.tag(1)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            //buton
            Button {
                //detect which tab it is
                if tabSelection == 0 {
                    tabSelection = 1
                }else{
                    //request for geolocation permission
                    model.requestGeolocationPermission()
                    
                }
            } label: {
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .cornerRadius(10
                        )
                    Text(tabSelection == 0 ? "Next" : "Get My Location")
                        .bold()
                        .padding()
                }
            }.accentColor(tabSelection == 0 ? blue : turquoise)

           Spacer()
        }
        .padding()
        .background(tabSelection == 0 ? blue : turquoise)
        .ignoresSafeArea()
        
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}

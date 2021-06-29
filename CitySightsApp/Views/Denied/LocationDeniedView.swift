//
//  LocationDeniedView.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/29/21.
//

import SwiftUI

struct LocationDeniedView: View {
    
    let backgroundColor = Color(red: 34.0/255.0, green: 141.0/255.0, blue: 138.0/255.0)
    
    var body: some View {
        VStack(spacing: 20){
            
            Spacer()
            
            Text("Whoops!")
                .font(.title)
            
            Text("We need to access your location to provide you with the best sights in the city. You can change you decisin at any time in Settings")
            
            Spacer()
            
            Button {
                //open settings by getting the setting url
                if let url = URL(string: UIApplication.openSettingsURLString){
                    if UIApplication.shared.canOpenURL(url){
                        //if we can open this settings url, then open it
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                    }
                }
                
            } label: {
                
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .cornerRadius(10)
                        
                    Text("Go to Settings")
                        .bold()
                        .foregroundColor(backgroundColor)
                        .padding()
                }
                
            }
            .padding()

            
            Spacer()
        }
        .padding()
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .background(backgroundColor)
        .ignoresSafeArea()
    }
}

struct LocationDeniedView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDeniedView()
    }
}

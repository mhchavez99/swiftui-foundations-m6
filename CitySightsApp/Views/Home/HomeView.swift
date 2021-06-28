//
//  HomeView.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/25/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var isMapShowing = false
    
    var body: some View {
        
        if model.sights.count != 0 || model.restaurants.count != 0{
            
            NavigationView{
             
                //determine if we should show list or map
                if !isMapShowing{
                    //show list
                    
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName: "location")
                            Text("San Francisco")
                            Spacer()
                            
                            Button("Switch to map view") {
                                self.isMapShowing = true
                            }
                            
                        }
                        Divider()
                        
                        BusinessList()
                    }
                    .padding([.horizontal, .top])
                    .navigationBarHidden(true)
                    
                }
                else{
                    // show map
                    BusinessMap()
                        .ignoresSafeArea()
                }
            }
            
        }else{
            //still waiting for data, show spinner
            ProgressView()
        }
        
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

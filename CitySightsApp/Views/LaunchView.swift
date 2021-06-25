//
//  LaunchView.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/24/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
        //detect authorization status for geolocation
        
        if model.authorizationState == .notDetermined {
            //if undetermined show onboarding
        }else if model.authorizationState == .authorizedAlways ||
                    model.authorizationState == .authorizedWhenInUse {
            //if authorized show home view
            HomeView()
            
        }else{
            //if denied show denied view
            //DeniedView()
            
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

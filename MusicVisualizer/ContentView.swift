//
//  ContentView.swift
//  MusicVisualizer
//
//  Created by Hritik Raj on 5/9/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var conductor: Conductor
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            FFTView(data: conductor.amplitudes)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Conductor.shared)
    }
}

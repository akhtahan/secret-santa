//
// ShopsPage.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-12-10.
// 
//
// 
//


import SwiftUI
import MapKit

struct ShopsPage: View {
    
    var places: [Place]
    
    var body: some View {
        
        if (places.isEmpty) {
            VStack {
                Image("santa")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                Text("Sorry, can't find your location!")
                    .font(.headline)
                    .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
        }
        else{
            NavigationView {
                VStack(alignment: .center) {
                    List(places, id: \.self) { place in
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .padding(.trailing, 9)
                                VStack(alignment: .leading) {
                                    Text(place.name)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Text(place.address)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }// HStack
                            .onTapGesture {
                                getDirections(address: place.address)
                            }
                    }
                }
                .navigationTitle("Shop Recommendations")
            }//navigation view
            
        }//else
    }
}

func getDirections(address : String){
    openMap(address: address)
}

    
//    struct ShopsPage_Previews: PreviewProvider {
//        static var previews: some View {
//            ShopsPage(places: [
//                Place(name: "Shop1", address: "123 Main St"),
//                Place(name: "Shop2", address: "456 Elm St"),
//            ])
//        }
//    }
    
    struct ShopsPage_Previews: PreviewProvider {
        static var previews: some View {
            ShopsPage(places: [])
        }
    }


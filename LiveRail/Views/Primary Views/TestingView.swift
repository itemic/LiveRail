//
//  TestingView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct TestingView: View {
    @ObservedObject var data: HSRDataStore
    @State private var offset = CGSize.zero

    var body: some View {
        
        ZStack {
            //MARK: One
            ScrollView {
                VStack {
                    ForEach(data.stations) { station in
                        HStack {
                            Text("STATION: \(station.StationName.En)")
                        }
                    }
                }
            }
            
            
            //MARK: Two
            VStack {
                Spacer()
                VStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10, style:.continuous)
                        .fill(Color.primary)
                        .frame(width: 100, height: 5)
                    HStack {
                        VStack {
                            VStack {

                                Text("HSINCHU")
                                    .foregroundColor(.white)
                                    .font(.title2).bold()

                            }.frame(maxWidth: .infinity, maxHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.accentColor)
                            )


                        }
                        Spacer()
                        VStack {
                            VStack {

                                Text("HSINCHU")
                                    .foregroundColor(.white)
                                    .font(.title2).bold()

                            }.frame(maxWidth: .infinity, maxHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.accentColor)
                            )


                        }
                    }
                }
                .padding()
                .background(BlurView())
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                .padding()
            }.edgesIgnoringSafeArea(.all)
            .offset(x: 0, y: offset.height * 5)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.offset = gesture.translation
                    }

                    .onEnded { _ in
                        if abs(self.offset.height) > 100 {
                            // remove the card
                            self.offset = .zero
                        } else {
                            self.offset = .zero
                        }
                    }
            )
        }
        
        
        
        
        
    }
}



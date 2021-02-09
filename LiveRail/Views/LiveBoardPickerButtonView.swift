//
//  LiveBoardPickerButtonView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/22/21.
//

import SwiftUI



struct LiveBoardPickerButtonView: View {
    var station: LocalizedStringKey
    @Binding var activeTimetable: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    withAnimation {
                        activeTimetable = true
                    }
                }) {
                            Text(station)
                }
                .buttonStyle(OpacityChangingButton(.purple))
                                    
            }
            .padding()
            .padding(.bottom, 15)
            .background(BlurView())
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//struct LiveBoardPickerButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LiveBoardPickerButtonView()
//    }
//}

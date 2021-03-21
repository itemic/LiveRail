//
//  DataDisclaimerView.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/14/21.
//

import SwiftUI

struct DataDisclaimerView: View {
    var body: some View {
        List {
            
            Section {
                VStack(spacing: 8) {
                Text("Thank you! 😊").font(.title3).bold()
                    Text("Thank you for downloading! I really hope you find it useful. If you enjoy using it, I would appreciate it a lot if you could give it a review.").font(.subheadline)
                .multilineTextAlignment(.center)
                Button(action: {
                    guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1550589269?action=write-review")
                            else { fatalError("Expected a valid URL") }
                        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                }, label: {
                    Text("Review")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                })
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(5)
            }
            
            Section {
                VStack {
                    Image("ptxlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                Text("Transit data is provided by the PTX Transport API. 資料介接「交通部PTX平臺」。")
                    
                }
                .padding()
            }
                
            
            Text("TIME_ZONE_DISCLAIMER")
                .padding()
            
            
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(InsetGroupedListStyle())
    }
}

struct DataDisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        DataDisclaimerView()
    }
}

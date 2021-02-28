//
//  SlideoverSheetView.swift
//  LiveRail
//
//  Created by Terran Kroft on 2/23/21.
//

import SwiftUI



struct SlideoverSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    let content: Content
    @State private var offset = CGSize.zero
    @State private var gestureT = CGSize.zero

    

    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {

        self.content = content()
                self._isOpen = isOpen
    }
    
    func sendHaptics() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred(intensity: 0.5)
    }

    var body: some View {
        
        ZStack {
            
                if (isOpen) {
                    Color.white.opacity(0.0)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                isOpen = false
                            }
                        }
                }

                GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                    VStack {
                        self.content
                        Spacer()
                            .frame(height: UIScreen.main.bounds.height * 0.075)
                    }
                    .padding(.horizontal)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.85)
                    .background(BlurView(style: .systemChromeMaterial))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .animation(.easeInOut(duration: 0.25))
                .transition(AnyTransition.move(edge: .bottom))
                .offset(y: (self.isOpen ? self.offset.height + self.gestureT.height + UIScreen.main.bounds.height * 0.075 : geo.size.height))
                }
                .onTapGesture {}
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            
                            if (gesture.translation.height > UIScreen.main.bounds.height * -0.075) {
                                self.gestureT = gesture.translation
                            }
                        }
                        .onEnded { _ in
                            
                            if (self.gestureT.height > 100) {
                               
                            isOpen = false
                            }
                            self.gestureT = .zero
                        }
                )
           
            
            
        }
        .zIndex(100)
        .onChange(of: isOpen) { value in
            if (value) {
            sendHaptics() // only on open
            }
        }
        
        
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

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
        
        ZStack(alignment: .center) {
            
            
            
                if (isOpen) {
                    Rectangle()
//                        .fill(.white.opacity(isOpen ? 0.1 : 0))
                        .background(.ultraThinMaterial)
//                    Color.white.opacity(0.5)
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
//                    .frame(idealHeight: UIScreen.main.bounds.height * 0.85, maxHeight: UIScreen.main.bounds.height * 0.85)
                    
                    .background(BlurView(style: .systemChromeMaterial))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                    
                .animation(.easeInOut(duration: 0.25), value: isOpen)
                
                .transition(AnyTransition.move(edge: .bottom))
                .offset(y: (self.isOpen ? self.gestureT.height + UIScreen.main.bounds.height * 0.075 : geo.size.height))
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
                                withAnimation {
                            isOpen = false
                                }
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

//
//  LogoView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/12/23.
//

// TODO: Fix hiccup going into final bounce up

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides an animated logo view
struct LogoView: View {

    // MARK: - Properties

    // State

    @State private var discOffsetY = -500.0
    @State private var drawerOffsetY = 0.0

    @State private var redOffsetY = -500.0
    @State private var yellowOffsetY = -500.0
    @State private var blueOffsetY = -500.0

    // Basic

    let discWidthMultiplier = 0.37
    let discOffsetYFinal = -75.0
    let discDropDuration = 0.2

    // MARK: - Body view

    var body: some View {
        GeometryReader { geo in
            ZStack {

                // Background
                Color.mint
                    .ignoresSafeArea()

                // Discs group
                Group {

                    // Blue disc
                    Image("blue-disc")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * discWidthMultiplier)
                        .offset(x: 45, y: blueOffsetY)

                    // Yellow disc
                    Image("yellow-disc")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * discWidthMultiplier)
                        .offset(x: 0, y: yellowOffsetY)

                    // Red disc
                    Image("red-disc")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * discWidthMultiplier)
                        .offset(x: -45, y: redOffsetY)
                }

                // Drawer
                Image("drawer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.7)
                    .offset(x: 0, y: drawerOffsetY)
            }
            .onAppear {

                // Disc drop animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.linear(duration: discDropDuration)) {
                        setAllDiscsOffsetY(discOffsetYFinal)
                    }
                }

                // Drawer + disc slight drop animation
                DispatchQueue.main.asyncAfter(deadline: .now() + discDropDuration + 0.3) {
                    withAnimation(.easeOut) {
                        drawerOffsetY = 50.0
                        setAllDiscsOffsetY(0.0)
                    }
                }

                // Drawer + disc return animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 + 0.3) {
                    withAnimation(.easeIn(duration: 0.16)) {
                        drawerOffsetY = 0.0
                        setAllDiscsOffsetY(discOffsetYFinal)
                    }
                }

                // Disc jump animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.76 + 0.3) {
                    withAnimation(Animation.timingCurve(0.1, 1, 0.95, 1, duration: 0.2)) {
                        redOffsetY = discOffsetYFinal - 50
                        yellowOffsetY = discOffsetYFinal - 30
                        blueOffsetY = discOffsetYFinal - 70
                    }
                }

                // Disc return animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.96 + 0.3) {
                    withAnimation(Animation.timingCurve(0.9, 0.05, 0.95, 1, duration: 0.2)) {
                        setAllDiscsOffsetY(discOffsetYFinal)
                    }
                }
            }
        }
    }

    // Helper func to set all disc Y offsets at once
    func setAllDiscsOffsetY(_ offsetY: CGFloat) {
        redOffsetY = offsetY
        yellowOffsetY = offsetY
        blueOffsetY = offsetY
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}

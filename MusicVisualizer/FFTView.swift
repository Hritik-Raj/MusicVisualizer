//
//  FFTView.swift
//  MusicVisualizer
//
//  Created by Hritik Raj on 5/9/21.
//

import SwiftUI

import SwiftUI

struct FFTView_Previews: PreviewProvider {
    static var previews: some View {
        FFTView(data: Array(repeating: 0.0, count: 50))
    }
}

//struct FFTView: View {
//    var amplitudes: [Double]
//    var linearGradient : LinearGradient = LinearGradient(gradient: Gradient(colors: [.red, .yellow, .green]), startPoint: .top, endPoint: .center)
//    var paddingFraction: CGFloat = 0.2
//    var includeCaps: Bool = true
//
//    var body: some View {
//        HStack(spacing: 0.0){
//            ForEach(0 ..< self.amplitudes.count) { number in
//                AmplitudeBar(amplitude: amplitudes[number], linearGradient: linearGradient, paddingFraction: paddingFraction, includeCaps: includeCaps)
//            }
//        }
//        .background(Color.black)
//    }
//}


struct FFTView: View {
    var data: [Double]
      
      var body: some View {
        GeometryReader { geo in
          Path { [data = self.data] path in
            guard data.count > 0 else { return }

            let bounds = geo.frame(in: .local)
            let insetBounds = bounds.insetBy(dx: 20.0, dy: 20.0)

            let width = insetBounds.width
            let height = insetBounds.height
            let halfHeight = height / 2.0

            let yForData = { (value: Float) in
              return insetBounds.minY + halfHeight + (halfHeight * CGFloat(value))
            }

            path.move(to: CGPoint(x: insetBounds.minX, y: yForData(Float(data[0]))))

            for i in 1..<data.count {
              let x = insetBounds.minX + (width * (CGFloat(i) / CGFloat(data.count)))
                let y = yForData(Float(data[i]))
              path.addLine(to: CGPoint(x: x, y: y))
            }
          }
          .stroke(Color.white, lineWidth: 4.0)
          .background(Color.black)
          .drawingGroup()
        }
      }
}

struct AmplitudeBar: View {
    var amplitude: Double
    var linearGradient : LinearGradient
    var paddingFraction: CGFloat = 0.2
    var includeCaps: Bool = true
    
    var body: some View {
        GeometryReader
            { geometry in
            ZStack(alignment: .bottom){
                
                // Colored rectangle in back of ZStack
                Rectangle()
                    .fill(self.linearGradient)
                
                // Dynamic black mask padded from bottom in relation to the amplitude
                Rectangle()
                    .fill(Color.black)
                    .mask(Rectangle().padding(.bottom, geometry.size.height * CGFloat(amplitude)))
                    .animation(.easeOut(duration: 0.15))
                
                // White bar with slower animation for floating effect
                if(includeCaps){
                    addCap(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .padding(geometry.size.width * paddingFraction / 2)
            .border(Color.black, width: geometry.size.width * paddingFraction / 2)
        }
    }
    
    // Creates the Cap View - seperate method allows variable definitions inside a GeometryReader
    func addCap(width: CGFloat, height: CGFloat) -> some View {
        let padding = width * paddingFraction / 2
        let capHeight = height * 0.005
        let capDisplacement = height * 0.02
        let capOffset = -height * CGFloat(amplitude) - capDisplacement - padding * 2
        let capMaxOffset = -height + capHeight + padding * 2
        
        return Rectangle()
            .fill(Color.white)
            .frame(height: capHeight)
            .offset(x: 0.0, y: -height > capOffset - capHeight ? capMaxOffset : capOffset) //ternary prevents offset from pushing cap outside of it's frame
            .animation(.easeOut(duration: 0.6))
    }
    
}

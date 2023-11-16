//
//  SVGImageView.swift
//  ListOfSmartThings_TestTask
//
//  Created by Поляндий on 31.10.2023.
//

import SwiftUI
//import SwiftSVG

//struct SVGImageView: UIViewRepresentable {
//    
//    let url: String
//    let size: CGSize
//    
//    init(_ url: String, size: CGSize = CGSize(width: 98, height: 98)) {
//        self.url = url
//        self.size = size
//    }
//
//    func makeUIView(context: Context) -> UIView {
//        let svgView = UIView()
//        
//        if let imageUrl = URL(string: "https://api.fasthome.io\(self.url)") {
//            
//            
//            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
//                if let data = data {
//                    
//                    DispatchQueue.main.async {
//                        
//                        let svgLayer = CALayer(SVGData: data, completion: {_ in })
//                        svgLayer.contentsGravity = .resizeAspect
//                        svgLayer.frame = CGRect(origin: .zero, size: size)
//                        svgLayer.masksToBounds = true
//                        
//                        svgView.layer.addSublayer(svgLayer)
//                    }
//                }
//            }.resume()
//        }
//        
//        return svgView
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//    }
//}

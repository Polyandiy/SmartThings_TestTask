//
//  CustomAlertView.swift
//  ListOfSmartThings_TestTask
//
//  Created by Поляндий on 30.10.2023.
//

import SwiftUI

struct CustomAlertView: View {
    
    @Binding var selectedDevice: Device?
    
    var destructiveAction: (() -> ())?
    var cancelAction: (() -> ())?
    
    var body: some View {
        
        VStack {
            Text("Вы хотите удалить \(self.selectedDevice?.name ?? "") ?")
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .font(.custom("Roboto-Regular", size: 24))
                .padding()
            
            Spacer()
            
            HStack(alignment: .center, spacing: 9) {
                Button {
                    
                    cancelAction?()
                    
                } label: {
                    Text("Отмена")
                        .font(.custom("Roboto-Regular", size: 14))
                        .textCase(.uppercase)
                        .padding(EdgeInsets(top: 12, leading: 35, bottom:12, trailing: 35))
                        .background(Color(hex: "BFC5CF"))
                        .clipShape(Capsule())
                }
                
                Button {
                    
                    destructiveAction?()
                    
                } label: {
                    Text("Удалить")
                        .font(.custom("Roboto-Regular", size: 14))
                        .textCase(.uppercase)
                        .padding(EdgeInsets(top: 12, leading: 35, bottom:12, trailing: 35))
                        .background(Color(hex: "FF6969"))
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
        .frame(width: 299, height: 201)
        .background(.white)
        .cornerRadius(24)
    }
}

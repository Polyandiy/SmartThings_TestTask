//
//  ContentView.swift
//  SmartThings_TestTask
//
//  Created by Поляндий on 16.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = SmartThingsViewModel()
    @State private var startPoint: UnitPoint = .init(x: -1, y: 0.5)
    @State private var endPoint: UnitPoint = .init(x: 0, y: 0.5)
    
    var body: some View {
        
        ZStack {
            Color("BackgroundColorApp").edgesIgnoringSafeArea(.all)
            
            if viewModel.loadingStatus != .error {
                VStack(alignment: .leading) {
                    
                    Text("Умные \nвещи")
                        .font(.custom("Roboto-Regular", size: 28))
                        .foregroundColor(.purple)
                        .padding()
                    
                    ScrollView {
                        
                        LazyVStack (spacing: 20) {
                            if viewModel.loadingStatus == .loading {
                                
                                ForEach(0..<4, id: \.self) { _ in
                                    
                                    emptyCell
                                        .padding(.all)
                                    
                                }
                            } else if viewModel.loadingStatus == .loaded {
                                
                                ForEach(viewModel.devices, id: \.self) { dev in
                                    
                                    cell(dev)
                                        .padding(.all)
                                        .swipeActions(edge: .trailing) {
                                            
                                            Button {
                                                
                                                viewModel.selectedDevice = dev
                                                viewModel.showAlert.toggle()
                                                
                                            } label: {
                                                Image(systemName: "trash.fill")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .background(Color("BackgroundColorApp"))
                }
            } else {
                VStack {
                    
                    Text("Что-то пошло не так, \nошибка 123")
                        .font(.custom("Roboto-Regular", size: 24))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    Button {
                        
                        viewModel.loadingStatus = .loading
                        viewModel.loadDevicesFromCache(withName: viewModel.nameCache)
                        
                    } label: {
                        Text("Повторить")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.white)
                            .textCase(.uppercase)
                            .padding(EdgeInsets(top: 14, leading: 24, bottom:14, trailing: 24))
                            .background(Color(hex: "232198"))
                            .clipShape(Capsule())
                    }
                }
            }
            
            if viewModel.showAlert {
                
                CustomAlertView(selectedDevice: $viewModel.selectedDevice) {
                    viewModel.removeDeviceFromCache(id: viewModel.selectedDevice?.id ?? 0)
                } cancelAction: {
                    viewModel.showAlert = false
                }
            }
        }
        .blur(radius: viewModel.showAlert ? 30 : 0)
        .overlay(alignment: .bottomTrailing) {
            Button {
                
                viewModel.loadingStatus = .loading
                viewModel.getData()
                
            } label: {
                
                Text("ОБНОВИТЬ")
                    .font(.custom("Roboto-Regular", size: 18))
                    .padding(EdgeInsets(top: 14, leading: 24, bottom:14, trailing: 24))
                    .background(Color.white)
                    .clipShape(Capsule())
            }.isHidden(viewModel.loadingStatus != .loaded)
        }
    }
    
    
    //MARK: - cells
    @ViewBuilder
    func cell(_ item: Device?) -> some View {
        
        if let name = item?.name, let status = item?.status, let iconURL = item?.icon, let state = item?.isOnline {
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(state ? .green : .red)
                                .frame(width: 12, height: 12)
                            
                            Text(state ? "ON LINE" : "OFF LINE")
                                .foregroundColor(.white)
                                .font(.custom("Roboto-Regular", size: 15))
                        }
                        
                        Text(name)
                            .font(.custom("Roboto-Regular", size: 30))
                            .textCase(.uppercase)
                            .lineLimit(2)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    //                    SVGImageView(iconURL)
                    //                        .frame(width: 98, height: 98)
                    //по получаемым ссылкам - пустое изображение, но данная реализация точно работает, проверенно на сторонних ссылках с svg изображениями
                }
                .padding(.all)
                
                Spacer()
                
                HStack {
                    
                    HStack {
                        Image("Rocket")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 14)
                        
                        Text(status)
                            .font(.custom("Roboto-Regular", size: 15))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color("WorkStatusColorApp"))
                    .cornerRadius(50)
                    
                    Spacer()
                    
                    Image("clock")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    
                    Text(viewModel.dateFormatting(item?.lastWorkTime))
                        .font(.custom("Roboto-Regular", size: 15))
                }
                .padding(.all)
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(hex: "AB69FF"), Color(hex: "494BEB")]), startPoint: .top, endPoint: .bottom)
                    .cornerRadius(20)
            )
        }
    }
    
    //MARK: - emptyCells
    @ViewBuilder
    var emptyCell: some View {
        
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color.secondary)
                            .frame(width: 12, height: 12)
                        
                        
                        Rectangle()
                            .foregroundColor(Color.secondary)
                            .cornerRadius(10)
                            .frame(width: 46, height: 14)
                    }
                    
                    Rectangle()
                        .foregroundColor(Color.secondary)
                        .cornerRadius(10)
                        .frame(width: 168, height: 28)
                    
                    Spacer()
                }
                
                Spacer()
                
                Image(systemName: "circle.fill")
                    .resizable()
                    .foregroundColor(Color.clear)
                    .frame(width: 98, height: 98)
                
            }
            .padding(.all)
            
            Spacer()
            
            HStack {
                Rectangle()
                    .foregroundColor(Color.secondary)
                    .cornerRadius(10)
                    .frame(width: 130, height: 28)
            }
            .padding(.all)
        }
        .background(
            LinearGradient(colors: [.gray, .clear, .gray], startPoint: startPoint, endPoint: endPoint)
                .onAppear{
                    DispatchQueue.main.async {
                        withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                            startPoint = .init(x: 1, y: 0.5)
                            endPoint = .init(x: 2, y: 0.5)
                        }
                    }
                }
        )
        .cornerRadius(20)
    }
}


//
//  InputView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 08.01.21.
//

import SwiftUI

struct InputView: View {
    @EnvironmentObject var environment: ProjectEnvironment
    @State var result: String = ""
    @Binding var resultFloat: Float {
        didSet{
            environment.user.setTimeAccount(value: resultFloat)
        }
    }
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("\(result)")
                        .font(.system(size: 45))
                }
                .frame(width: 250, height: 50)
                .padding()
                
                VStack(spacing: 20){
                    ForEach(0...2, id: \.self) { i in
                        HStack(spacing: 20){
                            ForEach(1...3, id: \.self) { j in
                                Button(action:{
                                    addNumber(num: String(j+3*i))
                                }){
                                    Image(systemName: "\(j+3*i).circle.fill")
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                }
                            }
                        }
                    }
                    HStack(spacing: 20){
                        Button(action: {
                            if result.isEmpty {
                                addNumber(num: "0.")
                            }else if !result.contains("."){
                                addNumber(num: ".")
                            }
                        }){
                            CommaImage()
                        }
                        Button(action: {
                            if !result.isEmpty { addNumber(num: "0") }
                        }){
                            Image(systemName: "0.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                        }
                        Button(action: {
                            clearResult()
                        }){
                            Image(systemName: "c.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            .padding(.vertical, 30)
            .navigationBarTitle("Set Time", displayMode: .inline)
            .navigationBarItems(leading:
                    Button(action: {
                        showSheet = false
                    }){
                        Text("Back")
                    }, trailing:
                    Button(action: {
                        resultFloat = Float(result) != nil ? Float(result)! : 0
                        showSheet = false
                    }){
                        Text("Done")
                    }
            )
        }
    }
    
    private func addNumber(num: String) {
        if result.count < 3 && !result.contains(".") || num == "." || result.suffix(2).contains(".") {
            result += num
        }
    }
    private func clearResult() { result = "" }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(resultFloat: .constant(0), showSheet: .constant(false))
            .preferredColorScheme(.light)
    }
}

struct CommaImage: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 70, height: 70)
            Text(",")
                .font(.system(size: 100))
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .frame(width: 20, height: 10)
                .padding(.bottom, 65)
        }
    }
}

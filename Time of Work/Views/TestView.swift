//
//  TestView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 27.11.20.
//

import SwiftUI

struct TestView: View {
    @State var showSheet = false
        var body: some View {
            VStack {
                Text("Hello, world!").padding()
                Button("Show sheet") {
                    showSheet = true
                }
            }
            .sheet(isPresented: $showSheet) {
                SheetView()
            }
        }
    }
    struct SheetView: View {
        @State var greenBiggerBox = false
        var body: some View {
            VStack {
                Toggle("Show bigger box", isOn: $greenBiggerBox)
                if greenBiggerBox {
                    Rectangle().frame(width: 640, height: 480).foregroundColor(.green)
                } else {
                    Rectangle().frame(width: 320, height: 240).foregroundColor(.red)
                }
            }.padding()
            .frame(width: 200, height: 200)
        }
    }
struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

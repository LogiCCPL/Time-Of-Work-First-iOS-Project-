//
//  TEST01.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 06.01.21.
//

import SwiftUI

struct PausePicker: View {
    @State var selection1: Int = 0
    @State var selection2: Int = 0
    @Binding var date: Date
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    HStack{

                        Picker("", selection: $selection1){
                            ForEach(0...23, id: \.self){ i in
                                    Text("\(i)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                        .frame(width: geometry.size.width/2, height: geometry.size.height)
                        .fixedSize()
                        .clipped()
                        .onChange(of: selection1) { new in
                            let m = Calendar.current.component(.minute, from: date)
                            date = Calendar.current.date(bySettingHour: new, minute: m, second: 0, of: date)!
                        }

                        
                        Picker("", selection: $selection2){
                            ForEach(0...59, id: \.self){ i in
                                Text("\(i)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                        .frame(width: geometry.size.width/2, height: geometry.size.height)
                        .fixedSize()
                        .clipped()
                        .onChange(of: selection2) { new in
                            let h = Calendar.current.component(.hour, from: date)
                            date = Calendar.current.date(bySettingHour: h, minute: new, second: 0, of: date)!
                        }

                    }
                    HStack{
                        HStack{
                            Text("hour")
                                .padding(.trailing, 25)
                        }
                        .frame(width: geometry.size.width/2.1, height: geometry.size.height, alignment: .trailing)
                        
                        HStack{
                            Text("min")
                                .padding(.trailing, 25)
                        }.frame(width: geometry.size.width/2.1, height: geometry.size.height, alignment: .trailing)
                    }
                }
        }
    }
}

struct PausePicker_Previews: PreviewProvider {
    static var previews: some View {
        PausePicker(date: .constant(Date()))
    }
}

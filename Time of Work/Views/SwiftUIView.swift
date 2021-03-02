//
//  SwiftUIView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 06.01.21.
//

import SwiftUI

struct SwiftUIView: View {
    @State var num: String = ""
    var body: some View {
        Form{
            Section{
                TextField("", text: $num)
                
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

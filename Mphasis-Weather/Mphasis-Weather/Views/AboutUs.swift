//
//  AboutUs.swift
//  Mphasis-Weather
//
//  Created by CHB on 8/12/24.
//

import SwiftUI

struct AboutUs: View {
    var presentingVC: UIViewController?
    
    var body: some View {
        VStack {
            Button(action: {
                self.presentingVC?.presentedViewController?.dismiss(animated: true)
                }) {
                Group {
                    HStack {
                        
                        Text("Back")
                            .bold()
                            .font(.system(size: 17.0))
                            .padding(.leading, 4.0)
                    }
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 60, height: 0)
                        .padding(.top, 6.0)
                }
            }
            Text("About Us")
                .font(.title2)
                .fontWeight(.bold)
                .padding()

            // This should be the last, put everything to the top
            Spacer()
        }
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
    }
}

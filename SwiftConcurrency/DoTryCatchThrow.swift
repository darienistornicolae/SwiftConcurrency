//
//  DoTryCatchThrow.swift
//  SwiftConcurrency
//
//  Created by Darie-Nistor Nicolae on 09.04.2023.
//

import SwiftUI

//do=catch
//try
//throw

class DoTryCatchThrowManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("Texting", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("Texting")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
//        if isActive {
//            return "Texting"
//        } else {
            throw URLError(.appTransportSecurityRequiresSecureConnection)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FInal text"
        } else {
            throw URLError(.appTransportSecurityRequiresSecureConnection)
        }
    }
}

class DoTryCatchThrowViewModel: ObservableObject {
    @Published var text: String = "Start"
    let manager = DoTryCatchThrowManager()
    
    func fetchTitle() {
        /*
       let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
        */
        
       
        
        do { //Once one of a "try" fails, it gets to catch block
            let newTitle = try? manager.getTitle3()
            // self.text = newTitle ?? "SS"
            if let newTitle = newTitle {
                self.text = newTitle
            }
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
            
        } catch let error {
            self.text = error.localizedDescription
        }
    }
    
}


struct DoTryCatchThrow: View {
    
    @StateObject var viewModel = DoTryCatchThrowViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background (Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoTryCatchThrow_Previews: PreviewProvider {
    static var previews: some View {
        DoTryCatchThrow()
    }
}

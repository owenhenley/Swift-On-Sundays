//
//  ContentView.swift
//  DadJokes
//
//  Created by Owen Henley on 23/09/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Joke.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Joke.setup, ascending: true)
    ]) var jokes: FetchedResults<Joke>
    @State private var showingAddJoke = false
    
    // MARK: - View
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [Color("Start"), Color("Middle"), Color("End")]), startPoint: .top, endPoint: .bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(jokes, id:\.setup) { joke in
                        JokeCard(joke: joke)
                    }
                }.padding()
            }
            
            Button("Add Joke") {
                self.showingAddJoke.toggle()
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .clipShape(Capsule())
            .foregroundColor(.white)
            .offset(y: 50)
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showingAddJoke) {
                AddView().environment(\.managedObjectContext, self.moc)
        }
    }
    
    func removeJokes(at offsets: IndexSet) {
        for index in offsets {
            let joke = jokes[index]
            moc.delete(joke)
        }
        
        do {
            try moc.save()
        } catch {
            print("Error saving")
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

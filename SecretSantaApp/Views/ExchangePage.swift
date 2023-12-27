import SwiftUI

struct ExchangePage: View {
    @EnvironmentObject var dbHelper: FireDBHelper
    @State private var currentUser: User?
    @State private var showAlert = false
    @State private var showView : Bool = false

    var body: some View {
        VStack {
            Image("santa")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(50)

            Button("Exchange Gifts") {
                if currentUser?.secretSantaOf == "" {
                    exchangeGift()
                } else {
                    showAlert = true
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(radius: 5)
            .scaleEffect(0.8)

            if (currentUser?.secretSantaOf != ""){
                    Text("You are assigned as Secret Santa of \((dbHelper.currentUser?.secretSantaOf) ?? "NA") ")
                        .foregroundColor(.green)
                        .opacity(1.0)
                        .animation(.easeInOut)
                .padding()

            } else {
                Text("Currently you are not a Secret Santa.")
            }
        }
        .padding()
        .onAppear() {
            dbHelper.retrieveSecretSanta { user in
                currentUser = user
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Change Secret Santa"),
                message: Text("You are already assigned a Secret Santa. Do you want to change them?"),
                primaryButton: .default(Text("Yes")) {
                    self.exchangeGift()
                },
                secondaryButton: .cancel(Text("No"))
            )
        }
    }

    func exchangeGift() {
        dbHelper.assignUserAsSecretSanta { }
    }
}

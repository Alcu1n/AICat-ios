//
//  PremiumView.swift
//  AIChatty
//

import SwiftUI
import ApphudSDK

struct PremiumPage: View {
    @EnvironmentObject var appStateVM: AICatStateViewModel

    var localePrice: String {
        appStateVM.monthlyPremium?.skProduct?.locatedPrice ?? "$-.-"
    }

    var product: ApphudProduct? {
        appStateVM.monthlyPremium
    }

    @State var isPurchasing: Bool = false

    @State var toast: Toast?

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    appStateVM.showPremumPage = false
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(16)
                }
                .tint(.primaryColor)
                .buttonStyle(.borderless)
            }
            Spacer()
            Text("AIChatty Premium")
                .font(.manrope(size: 36, weight: .bold))
                .fontWeight(.bold)
                .padding(.top, 20)

            VStack(alignment: .leading, spacing: 20) {
                FeatureView(title: "Answers from GPT Model", description: "Get accurate and relevant answers directly from the GPT Model.")
                FeatureView(title: "No limits for Dialogues", description: "Engage in unlimited dialogues without any restrictions.")
                FeatureView(title: "Higher word limit", description: "Enjoy extended conversations with a higher word limit per message.")
                FeatureView(title: "Get new features first", description: "Be the first to access and try out new and upcoming features.")
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
            Spacer()
            Button(action: {
                restore()
            }) {
                Text("Restore Purchases")
                    .underline()
                    .foregroundColor(.blue)
            }
            .buttonStyle(.borderless)
            Button(action: {
                Task {
                    await subscribeNow()
                }
            }) {
                ZStack {
                    Text(appStateVM.isPremium ? "Already Premium" : "Subscribe for \(localePrice)/month")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 40)
                        .opacity((product == nil || isPurchasing) ? 0 : 1)
                        .background(Color.blue)
                        .cornerRadius(8)
                    if appStateVM.monthlyPremium == nil || isPurchasing {
                        LoadingIndocator(themeColor: .white)
                            .frame(width: 20, height: 20)
                            .environment(\.colorScheme, .dark)
                    }
                }

            }
            .buttonStyle(.borderless)
            Text("Auto renewal monthly, cancel at anytime")
                .foregroundColor(.gray.opacity(0.6))
                .font(.manrope(size: 12, weight: .regular))
                .padding(.bottom, 10)

            HStack {
                Link(destination: URL(string: "https://epochpro.app/aicat_privacy")!) {
                    Text("Privacy Policy")
                        .underline()
                        .foregroundColor(.blue)
                }

                Text("|")
                    .padding(.horizontal, 4)

                Link(destination: URL(string: "https://epochpro.app/aicat_terms_of_use")!) {
                    Text("Terms of Use")
                        .underline()
                        .foregroundColor(.blue)
                }
            }
            .font(.footnote)
            .padding(.bottom, 20)
            Spacer()
        }
        .font(.manrope(size: 16, weight: .medium))
        .task {
            await appStateVM.fetchPayWall()
        }
        .background(Color.background.ignoresSafeArea())
        .toast($toast)
    }

    func subscribeNow() async {
        guard !isPurchasing, !appStateVM.isPremium else { return }
        if let product {
            isPurchasing = true
            let result = await Apphud.purchase(product)
            if result.success {
                toast = Toast(type: .success, message: "You get AIChatty Premium Now!", duration: 2)
            }
            if let error = result.error as? NSError {
                toast = Toast(type: .error, message: "Purchase failed, \(error.localizedDescription))", duration: 4)
            } else if result.error != nil {
                toast = Toast(type: .error, message: "Purchase failed!", duration: 2)
            }
            isPurchasing = false
        }
    }

    func restore() {
        guard !isPurchasing else { return }
        isPurchasing = true
        Apphud.restorePurchases { _, _, _ in
            isPurchasing = false
            if Apphud.hasPremiumAccess() {
                toast = Toast(type: .success, message: "You get AIChatty Premium Now!", duration: 2)
            } else {
                toast = Toast(type: .error, message: "You are not premium user!", duration: 2)
            }
        }
    }
}

struct FeatureView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "crown.fill")

                Text(LocalizedStringKey(title))
                    .font(.manrope(size: 16, weight: .bold))
            }

            Text(LocalizedStringKey(description))
                .font(.manrope(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .padding(.leading, 32)
        }
    }
}

struct PremiumPage_Previews: PreviewProvider {
    static var previews: some View {
        PremiumPage()
            .background(.background)
            .environment(\.colorScheme, .dark)
            .environmentObject(AICatStateViewModel())
    }
}


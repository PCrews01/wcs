//
//  HomeView.swift
//  wchs
//
//  Created by Paul Crews on 11/4/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct HomeView: View {
    @EnvironmentObject var user_model : UserModel
    @State var show_sheet : NewsArticle = NewsArticle(title: "", image: "", article_images: [], story: "", week: "")
    @State var show_news_details : Bool = false
    
    var body: some View {
        VStack{
                HStack{
                    Image("logo_wide_green")
                        .resizable()
                        .frame(width: 200, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                    let fn = user_model.current_user.name.components(separatedBy: " ")
                    Text("Welcome back, \(fn[0])")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(Color("PrimaryColor"))
                    
                }
                .padding(.horizontal)
                Divider()
                ScrollView{
                    WeatherPit()
                        .padding()
                    Text("Wolverine News")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .tint(Color("PrimaryColor"))
                    LazyVGrid(columns: getGridColumns(column: 3)) {
                        ForEach(wolverine_news.sorted(by: { artA, artB in
                            artA.week > artB.week
                        }), id:\.id){ news_article in
                            NewsCard(
                                image: news_article.image,
                                title: news_article.title,
                                story: news_article.story,
                                week: news_article.week,
                                article_images: news_article.article_images)
                            .onTapGesture {
                                show_sheet = NewsArticle(id: news_article.id, title: news_article.title, image: news_article.image,article_images: news_article.article_images, story: news_article.story, week: news_article.week)
                            }
                            .onChange(of: show_sheet.id) { oldValue, newValue in
                                show_news_details = true
                            }
                        }
                    }
                }.scrollIndicators(.hidden)
                Spacer()
            
        }
        .padding(.vertical)
        .sheet(isPresented: $show_news_details) {
            if show_sheet.id.count > 0 {
                    VStack{
                        Image(show_sheet.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                        Text(show_sheet.title)
                            .font(.title)
                            .fontWeight(.heavy)
                        Divider()
                        ScrollView{
                        Text(show_sheet.story)
                            .multilineTextAlignment(.leading)
                            .padding()
                            if show_sheet.article_images!.count > 0 {
                                LazyVGrid(columns: getGridColumns(column: show_sheet.article_images!.count > 1 ? 2 : 1), content: {
                                    ForEach(show_sheet.article_images!, id:\.self){
                                        article_pic in
                                        Image(article_pic)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                    }
                                    
                                })
                            }
                    }
                }
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HomeView()
}

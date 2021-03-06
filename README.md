#Sentimental Writer

### For when you want to import a lot of tweets, perform sentiment analysis, and then generate text.

##### Use Case for Hackathon

We are gauging Twitter's reaction to the GOP Debate. This app can be used to many other ends, but we knew that #GOPDebate would be a trending topic and we wanted to generate periodic updates on shifts in Twitter users' perception of the debate.

We researched coverage of Twitter and found a dearth of this type of analysis.

##### Other Use Cases for App

* Apple / Amazon developer conferences
* Sports events
* Academy Awards
* TV or Movie Premiers

##### Target Audience

The content generated here can be delivered as streaming updates on news websites or in RSS feeds; it can be tweeted (how meta!); and though we didn't provide one, we can also create a recap template to describe how certain topics, references, hashtags etc. fluctuated over a larger period of time.

##### Tools Used

To generate content, we are using Automated Insight's Wordsmith API, which allows users to easily generate text from uploaded spreadsheets and templates. As a proof of concept, we used the `sentimental` gem without much augmentation. If we pursue this further we would probably build an even more comprehensive sentiment analysis tool, or augment `sentimental`. The `twitter` gem is a great SDK for importing tweets, and we're using that as well.

##### Constraints

We were limited to 180 Twitter API requests every 15 minutes, so we set up a cron job to run every minute, and the method the cron job runs imports from the API 10x. This way, we were able to ensure we were getting all tweets from the API.

Twitter has a Streaming API which may have made importing easier, but it's still in its beginning phases and there is no way to receive a feed with certain search parameters (say, for a given hashtag).

Wordsmith-API does not allow spreadsheet uploads, and while we were intending to build that functionality into the app, we had to manually upload the spreadsheet via the Wordsmith front end.




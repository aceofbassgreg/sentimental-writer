# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160129170918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hashtags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "first"
    t.string   "last"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "references", force: :cascade do |t|
    t.integer  "tweet_id"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "references", ["person_id"], name: "index_references_on_person_id", using: :btree
  add_index "references", ["tweet_id"], name: "index_references_on_tweet_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweet_hashtags", force: :cascade do |t|
    t.integer  "tweet_id"
    t.integer  "hashtag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tweet_hashtags", ["hashtag_id"], name: "index_tweet_hashtags_on_hashtag_id", using: :btree
  add_index "tweet_hashtags", ["tweet_id"], name: "index_tweet_hashtags_on_tweet_id", using: :btree

  create_table "tweet_topics", force: :cascade do |t|
    t.integer  "tweet_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tweet_topics", ["topic_id"], name: "index_tweet_topics_on_topic_id", using: :btree
  add_index "tweet_topics", ["tweet_id"], name: "index_tweet_topics_on_tweet_id", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.string   "id_from_twitter"
    t.text     "text"
    t.string   "author_name"
    t.string   "author_screenname"
    t.string   "author_location"
    t.integer  "author_followers"
    t.integer  "retweet_count"
    t.integer  "favorite_count"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.float    "sentiment_score"
  end

end

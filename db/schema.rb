# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2015_07_11_014546) do

  create_table "medias", force: :cascade do |t|
    t.string "message_id"
    t.string "sid"
    t.string "account_sid"
    t.string "parent_sid"
    t.string "content_type"
    t.string "base_url"
    t.string "uri"
    t.datetime "downloaded_at"
    t.datetime "destroyed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description"
    t.datetime "described_at"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "to_phone", limit: 8
    t.integer "from_phone", limit: 8
    t.string "body"
    t.string "to_country"
    t.string "to_state"
    t.string "to_city"
    t.string "to_zip"
    t.string "num_media"
    t.string "from_country"
    t.string "from_state"
    t.string "from_city"
    t.string "from_zip"
    t.string "sms_sid"
    t.string "account_sid"
    t.string "twilio_api_version"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "media_url"
    t.string "message_type"
    t.datetime "sent_at"
    t.integer "phone_id"
  end

  create_table "phones", force: :cascade do |t|
    t.integer "phone_number", limit: 8
  end

end

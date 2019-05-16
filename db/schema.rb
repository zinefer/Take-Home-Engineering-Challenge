# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_190_516_210_826) do
  create_table 'boroughs', force: :cascade do |t|
    t.string 'name'
    t.string 'zone'
    t.string 'service_zone'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'trips', force: :cascade do |t|
    t.integer 'vehicle_type'
    t.datetime 'pick_up_time'
    t.datetime 'drop_off_time'
    t.integer 'pick_up_borough_id'
    t.integer 'drop_off_borough_id'
    t.float 'fare'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['drop_off_borough_id'], name: 'index_trips_on_drop_off_borough_id'
    t.index ['pick_up_borough_id'], name: 'index_trips_on_pick_up_borough_id'
  end
end

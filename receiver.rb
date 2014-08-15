# encoding: utf-8
require "bunny"
require_relative 'sender.rb'

CLIENT_NAME = ARGV.empty? ? 'customer_1' : ARGV.join(" ")

conn = Bunny.new
conn.start
ch = conn.create_channel

q = ch.queue(CLIENT_NAME)

puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
q.subscribe(:block => true) do |delivery_info, properties, body|
  puts " [x] Received #{body.inspect} from #{properties.app_id}"

  # process order...
  sleep 3

  # ack to server that order is done
  Sender.new('server', CLIENT_NAME).send('order done', properties.reply_to)

  # cancel the consumer to exit
  #delivery_info.consumer.cancel
end
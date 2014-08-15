# encoding: utf-8
require "bunny"

class Sender

  def initialize(queue, client_name)
    @client_name = client_name
    @connection = Bunny.new
    @connection.start
    ch = @connection.create_channel

    @queue = ch.queue(queue)
    @exchange = ch.default_exchange
  end

  def send(msg, reply_to)
    @exchange.publish(msg, :routing_key => @queue.name, :reply_to => reply_to, :app_id => @client_name)
    puts "Sent #{msg}"

    @connection.close
  end

end
#!/usr/bin/env ruby
require 'bunny'
require 'json'

require_relative 'lib/matcher'
require_relative 'lib/matcher_a'
require_relative 'lib/matcher_b'

class RegexMatcherServer
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
  end

  def start(queue_name)
    @queue = channel.queue(queue_name)
    @exchange = channel.default_exchange
    subscribe_to_queue
  end

  def stop
    channel.close
    connection.close
  end

  def loop_forever
    # This loop only exists to keep the main thread
    # alive. Many real world apps won't need this.
    loop { sleep 5 }
  end

  private

  attr_reader :channel, :exchange, :queue, :connection

  def subscribe_to_queue
    queue.subscribe do |_delivery_info, properties, payload|
      p "[#{properties.correlation_id}] Start processing..."
      result = regex_matcher(payload)

      exchange.publish(
        result.to_json,
        routing_key: properties.reply_to,
        correlation_id: properties.correlation_id
      )
      p "[#{properties.correlation_id}] Done"
    end
  end

  def regex_matcher(text)
    result = []
    lines = text.gsub(/ +/, " ").gsub("\r\n", "\n").split("\n")
    matcher_a = MatcherA.new
    matcher_b = MatcherB.new
    lines.each do |line|
      matched = matcher_a.match(line) || matcher_b.match(line)
      next unless matched
      result << matched
    end
    return result
  end
end

begin
  server = RegexMatcherServer.new

  puts 'Server starting, waiting RPC requests...'
  server.start('rpc_queue')
  server.loop_forever
rescue Interrupt => _
  server.stop
end
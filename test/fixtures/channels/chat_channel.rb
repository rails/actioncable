class ChatChannel < ActionCable::Channel::Base
  def subscribed
    stream_from "chat"
  end
end
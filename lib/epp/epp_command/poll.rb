class KonoEppPoll < KonoEppCommand
  def initialize( op = :req )
    super( nil, nil )

    command = root.elements['command']
    poll = command.add_element( "poll" )

    poll.add_attribute( "op", op.to_s )
  end

  def ack_id=( id )
    poll = root.elements['command/poll']

    poll.add_attribute( "msgID", id )
  end
end

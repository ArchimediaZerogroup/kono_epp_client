module KonoEppClient::Transport
  def read
    raise NotImplemented.new
  end

  def write
    raise NotImplemented.new
  end

  def close
    raise NotImplemented.new
  end
end

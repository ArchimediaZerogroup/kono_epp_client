module KonoEppClient::Transport
  class TcpTransport
    include KonoEppClient::Transport

    def initialize( server, port )
      @connection = TCPSocket.new( server, port )
      @socket     = OpenSSL::SSL::SSLSocket.new( @connection )

      # Synchronously close the connection & socket
      @socket.sync_close

      # Connect
      @socket.connect

      # Get the initial frame
      read
    end

    def read
     if old_server
          data = ""
          first_char = @socket.read(1)

          if first_char.nil? and @socket.eof?
            raise SocketError.new("Connection closed by remote server")
          elsif first_char.nil?
            raise SocketError.new("Error reading frame from remote server")
          else
             data << first_char

             while char = @socket.read(1)
                data << char

                return data if data =~ %r|<\/epp>\n$|mi # at end
             end
          end
       else
          header = @socket.read(4)

          if header.nil? and @socket.eof?
            raise SocketError.new("Connection closed by remote server")
          elsif header.nil?
            raise SocketError.new("Error reading frame from remote server")
          else
            unpacked_header = header.unpack("N")
            length = unpacked_header[0]

            if length < 5
              raise SocketError.new("Got bad frame header length of #{length} bytes from the server")
            else
              response = @socket.read(length - 4)
            end
          end
       end
    end

    def write
      if defined?( @socket ) and @socket.is_a?( OpenSSL::SSL::SSLSocket )
        @socket.close
        @socket = nil
      end

      if defined?( @connection ) and @connection.is_a?( TCPSocket )
        @connection.close
        @connection = nil
      end

      return true if @connection.nil? and @socket.nil?
    end

    def close
      if defined?( @socket ) and @socket.is_a?( OpenSSL::SSL::SSLSocket )
        @socket.close
        @socket = nil
      end

      if defined?( @connection ) and @connection.is_a?( TCPSocket )
        @connection.close
        @connection = nil
      end

      return true if @connection.nil? and @socket.nil?
    end
  private
    # Receive an EPP frame from the server. Since the connection is blocking,
    # this method will wait until the connection becomes available for use. If
    # the connection is broken, a SocketError will be raised. Otherwise,
    # it will return a string containing the XML from the server.
    def get_frame
      end

  end
end

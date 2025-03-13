RSpec.describe KonoEppClient::Server do

  let(:params) {
    {
      tag: "abc",
      password: "123123",
      server: "epp.pubtest.nic.it"
    }
  }

  let(:instance) { described_class.new(params) }

  describe "initialization" do

    it "base" do
      expect(instance).to have_attributes(
                            **params,
                            port: 700,
                            old_server: false,
                            lang: "en",
                            services: ["urn:ietf:params:xml:ns:domain-1.0", "urn:ietf:params:xml:ns:contact-1.0", "urn:ietf:params:xml:ns:host-1.0"],
                            extensions: [],
                            version: "1.0",
                            transport: :tcp,
                            transport_options: {},
                            timeout: 30,
                            ssl_version: :TLSv1
                          )
    end
  end

  describe "#open_connection" do

    it "default transport" do

      double = instance_double(KonoEppClient::Transport::TcpTransport)

      expect(KonoEppClient::Transport::TcpTransport).to receive(:new).with(params[:server], 700).and_return(double)

      expect { instance.open_connection }.to change { instance.instance_variable_get(:@connection) }.
        to(double)
    end

    context "transport http" do

      let(:params) {
        super().merge(
          transport: :http,
          transport_options: {cookie_file: "file_to_coockies"},
        )
      }

      it "use http transport" do
        double = instance_double(KonoEppClient::Transport::HttpTransport)

        expect(KonoEppClient::Transport::HttpTransport).to receive(:new).with(
          params[:server],
          700, ssl_version: :TLSv1, cookie_file: "file_to_coockies").and_return(double)

        expect { instance.open_connection }.to change { instance.instance_variable_get(:@connection) }.
          to(double)

      end

    end

  end

  describe "#login" do

    it {
      expect(instance).to receive(:send_command) do |command|
        expect(command.to_s).to have_tag("command>login") do
          with_tag("options>version", text: "1.0")
          with_tag("options>lang", text: "en")
          instance.services.each do |srv|
            with_tag("svcs>objuri", text: srv)
          end
          without_tag("svcs>svcextension")
        end
      end

      instance.login
    }

    context "with extensions" do
      let(:params) {
        super().merge(extensions: ["https://nome.estensione", "altra:estensione"])
      }

      it {
        expect(instance).to receive(:send_command) do |command|
          expect(command.to_s).to have_tag("command>login>svcs>svcextension") do
            with_tag("exturi", text: "https://nome.estensione")
            with_tag("exturi", text: "altra:estensione")
          end
        end

        instance.login

      }

    end

  end

end
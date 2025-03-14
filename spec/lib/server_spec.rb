RSpec.describe KonoEppClient::Server do

  let(:params) {
    {
      tag: "abc",
      password: "123123",
      server: "epp.pubtest.nic.it"
    }
  }

  let(:instance) { described_class.new(params) }

  ##
  # Impostazione per eseguire inviare comandi di login con estensione DNSSEC
  shared_context "dnssec activation" do
    let(:params) {
      super().merge(enable_dns_sec: true)
    }
  end

  ##
  # Forza l'istanza come se avessi avuto conferma di connessione tramite DNSSEC
  shared_context "dnssec activated" do
    let(:instance) {
      super().tap { |c| c.instance_variable_set(:@dns_sec_enabled, true) }
    }
  end

  describe "initialization" do

    it "base" do
      expect(instance).to have_attributes(
                            **params,
                            port: 700,
                            lang: "en",
                            services: ["urn:ietf:params:xml:ns:domain-1.0", "urn:ietf:params:xml:ns:contact-1.0", "urn:ietf:params:xml:ns:host-1.0"],
                            extensions: [],
                            version: "1.0",
                            transport: :http,
                            transport_options: {},
                            timeout: 30,
                            ssl_version: :TLSv1
                          )
    end

    it_behaves_like "dnssec activation" do

      it { expect(instance).to have_attributes(
                                 extensions: include("urn:ietf:params:xml:ns:secDNS-1.1",
                                                     "http://www.nic.it/ITNIC-EPP/extsecDNS-1.0"),
                                 dns_sec_enabled: false # questo viene abilitato rispetto alla risposta del NIC
                               )

      }

    end

  end

  describe "#open_connection" do

    let(:params) {
      super().merge(
        transport: :http,
      )
    }

    it "default transport" do

      double = instance_double(KonoEppClient::Transport::HttpTransport)

      expect(KonoEppClient::Transport::HttpTransport).to receive(:new).with(
        params[:server],
        700, ssl_version: :TLSv1, cookie_file: "abc.cookies.pstore").and_return(double)

      expect { instance.open_connection }.to change { instance.instance_variable_get(:@connection) }.
        to(double)
    end

    context "transport http" do

      let(:params) {
        super().merge(
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
        Nokogiri::XML(file_fixture("login_response.xml").read) # Si aspetta un XML di risposta
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
          Nokogiri::XML(file_fixture("login_response.xml").read) # Si aspetta un XML di risposta
        end

        instance.login

      }

    end

    it_behaves_like "dnssec activation" do

      it "requested" do
        expect(instance).to receive(:send_command) do |command|
          expect(command.to_s).to have_tag("command>login>svcs>svcextension") do
            with_tag("exturi", text: "http://www.nic.it/ITNIC-EPP/extsecDNS-1.0")
            with_tag("exturi", text: "urn:ietf:params:xml:ns:secDNS-1.1")
          end
          Nokogiri::XML(file_fixture("login_response_for_dnssec.xml").read) # Si aspetta un XML di risposta
        end

        instance.login

      end

      it "with response" do
        allow(instance).to receive(:send_request)
                             .and_return(file_fixture("login_response_for_dnssec.xml").read)

        expect {
          instance.login
          expect(instance).to be_dns_sec_enabled
        }.to change(instance, :dns_sec_enabled).to(true)

      end

      it "response for Registrar not accredited" do
        allow(instance).to receive(:send_request)
                             .and_return(file_fixture("login_response.xml").read)

        expect {
          instance.login
          expect(instance).not_to be_dns_sec_enabled
        }.not_to change(instance, :dns_sec_enabled)
      end

    end

  end

  describe "#create_domain" do

    let(:ds_data) {
      create(:ds_data)
    }

    it {
      expect(instance).to receive(:send_command) do |command|
        expect(command.to_s).to have_xpath("//domain:create//domain:name[text()='architest.it']", {"domain" => "urn:ietf:params:xml:ns:domain-1.0"})
        expect(command.to_s).not_to have_xpath("//extension//secDNS:create", {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"})
      end

      instance.create_domain(name: 'architest.it', nameservers: [])

    }

    it "impostando i dati del dnssec ma senza aver avuto conferma da NIC di poterlo usare" do
      expect(instance).to receive(:send_command) do |command|
        expect(command.to_s).not_to have_xpath("//secDNS:create", {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"})
      end

      instance.create_domain(name: 'architest.it', nameservers: [], dns_sec_data: [ds_data])
    end

    it_behaves_like "dnssec activated" do

      it "senza assegnare dnssec data non succede nulla" do
        expect(instance).to receive(:send_command) do |command|
          expect(command.to_s).not_to have_xpath("//secDNS:create", {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"})
        end

        instance.create_domain(name: 'architest.it', nameservers: [])
      end

      it "assegnando dei valori" do
        expect(instance).to receive(:send_command) do |command|
          expect(command.to_s).to have_xpath("//secDNS:create", {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"})
          expect(command.to_s).to have_xpath(
                                    "//secDNS:keyTag[text()='123']",
                                    {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"}
                                  )

        end

        instance.create_domain(name: 'architest.it', nameservers: [], dns_sec_data: [ds_data])
      end

    end

  end

  describe "#update_domain" do

    let(:ds_data_a) { create(:ds_data) }
    let(:ds_data_b) { create(:ds_data) }

    it {
      expect(instance).to receive(:send_command) do |command|
        expect(command.to_s).to have_xpath("//domain:update//domain:name[text()='architest.it']", {"xmlns:domain" => "urn:ietf:params:xml:ns:domain-1.0"})
        expect(command.to_s).not_to have_xpath("//extension//secDNS:update", {"xmlns:secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"})
      end

      instance.update_domain(name: 'architest.it')
    }

    it "impostando i dati del dnssec ma senza aver avuto conferma da NIC di poterlo usare" do
      expect(instance).to receive(:send_command) do |command|
        expect(command.to_s).not_to have_xpath("//secDNS:update", {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"})
      end

      instance.update_domain(name: 'architest.it', dns_sec_data: [KonoEppClient::DnsSec::Add.new(ds_data_a)])
    end

    it_behaves_like "dnssec activated" do

      it "senza assegnare dnssec data non succede nulla" do
        expect(instance).to receive(:send_command) do |command|
          expect(command.to_s).not_to have_xpath("//secDNS:update", {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"})
        end

        instance.update_domain(name: 'architest.it')
      end

      it "assegnando dei valori" do
        expect(instance).to receive(:send_command) do |command|
          expect(command.to_s).to have_xpath("//secDNS:update", {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"})

          expect(command.to_s).to have_xpath(
                                    "//secDNS:update//secDNS:add//secDNS:dsData//secDNS:keyTag[text()='#{ds_data_a.key_tag}']",
                                    {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"}
                                  )
          expect(command.to_s).to have_xpath(
                                    "//secDNS:update//secDNS:rem//secDNS:dsData//secDNS:keyTag[text()='#{ds_data_b.key_tag}']",
                                    {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"}
                                  )
        end

        instance.update_domain(name: 'architest.it', dns_sec_data: [
          KonoEppClient::DnsSec::Add.new(ds_data_a),
          KonoEppClient::DnsSec::Rem.new(ds_data_b)
        ])
      end

      it "cancello tutti i ds_data" do
        expect(instance).to receive(:send_command) do |command|
          expect(command.to_s).to have_xpath("//secDNS:update", {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"})

          expect(command.to_s).to have_xpath(
                                    "//secDNS:update//secDNS:rem//secDNS:all[text()='true']",
                                    {"secDNS" => "urn:ietf:params:xml:ns:secDNS-1.1"}
                                  )
        end

        instance.update_domain(name: 'architest.it', dns_sec_data: [
          KonoEppClient::DnsSec::RemAll.new
        ])
      end

    end

  end

end
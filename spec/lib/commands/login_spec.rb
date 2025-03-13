# frozen_string_literal: true

RSpec.describe KonoEppClient::Commands::Login do
  include_context "like epp command"

  let(:args) { [] }

  let(:instance) {
    KonoEppClient::Commands::Login.new(*args)
  }
  subject(:xml) { rendered.to_s }

  it "login", snapshot: "xml" do
    is_expected.to have_tag("command") do
      with_tag(:login)
      with_tag("cltrid", text: "ABC-12345")
    end
  end

  context "with id and password" do
    let(:args) { ["12", "password"] }
    it "login", snapshot: "xml" do
      is_expected.to have_tag("command") do
        with_tag(:login) do
          with_tag("clid", text: "12")
          with_tag("pw", text: "password")
        end
      end
    end
  end

  describe "tags" do
    where(:case_name, :method, :tag_matcher, :value, :no_value, :getter) do
      [
        [:lang, :lang, have_tag("command>login>options>lang", text: "en"), "en", nil, true],
        [:version, :version, have_tag("command>login>options>version", text: "1.0"), "1.0", nil, true],
        [:new_password, :new_password, have_tag("command>login>newpw", text: "password"), "password", nil, false],

        [:services, :services,
         lazy {
           have_tag("command>login>svcs") do
             with_tag("objuri", count: 2)
             with_tag("objuri", text: "valore1")
           end
         }, ["valore1", "valore2"], [], true],

        [
          :extensions, :extensions,
          lazy {
            have_tag("command>login>svcs>svcextension") do
              with_tag("exturi", count: 2)
              with_tag("exturi", text: "http://uri1.com/valore1")
            end
          }, ["http://uri1.com/valore1", "http://uri2.com/valore2"],
          [],
          true
        ]

      ]
    end

    with_them do

      subject { instance.send(method) }
      it "getter" do
        if getter
          is_expected.to eq no_value
        end
      end

      context "with value" do
        let(:instance) {
          super().tap { |e| e.send("#{method}=", value) }
        }
        it "getter" do
          if getter
            is_expected.to be == value
          end
        end
        it "xml", snapshot: "xml" do
          expect(xml).to tag_matcher
        end
      end
    end
  end

  # describe "#version" do
  #   subject { instance.version }
  #   it { is_expected.to be_nil }
  #
  #   context "with versione" do
  #     let(:instance) {
  #       super().tap { |e| e.version = "1.0" }
  #     }
  #     it { is_expected.to be == "1.0" }
  #     it "xml", snapshot: "xml" do
  #       expect(xml).to have_tag("command>login>options>version", text: "1.0")
  #     end
  #   end
  # end

end
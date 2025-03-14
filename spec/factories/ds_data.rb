FactoryBot.define do
  factory :ds_data, class: "KonoEppClient::DnsSec::DsData" do
    skip_create

    key_tag { 123 }
    alg { :dsa_sha_1 }
    digest_type { :sha_1 }
    digest { "4347d0f8ba661234a8eadc005e2e1d1b646c9682" }

    initialize_with { new(key_tag, alg, digest_type, digest) }
  end
end
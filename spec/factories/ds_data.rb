FactoryBot.define do
  factory :ds_data, class: "KonoEppClient::DsData" do
    skip_create

    key_tag { 123 }
    alg { :dsa_sha_1 }
    digest_type { :sha_1 }
    digest { "digest" }

    initialize_with { new(key_tag, alg, digest_type, digest) }
  end
end
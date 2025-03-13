# frozen_string_literal: true
module KonoEppClient
  class DsData < REXML::Element

    attr_accessor :key_tag, :alg, :digest_type, :digest

    ALG = {
      :dsa_sha_1 => 3,
      :rsa_sha_1 => 5,
      :dsa_nsec_3_sha_1 => 6,
      :rsasha_1_nsec_3_sha_1 => 7,
      :rsa_sha_256 => 8,
      :rsa_sha_512 => 10,
      :ecc_gost => 12,
      :ecdsap_256_sha_256 => 13,
      :ecdsap_384_sha_384 => 14
    }.freeze
    DIGEST_TYPES = {
      :sha_1 => 1,
      :sha_256 => 2,
      :gost_r_34_11_94 => 3,
      :sha_384 => 4
    }.freeze

    ##
    # Inizializzazione di un DsData
    #
    # @param [Integer] key_tag 0<=X<=65535
    # @param [Symbol] alg
    #              :dsa_sha_1                  =>  3 (DSA/SHA-1)
    #              :rsa_sha_1                  =>  5 (RSA/SHA-1)
    #              :dsa_nsec_3_sha_1           =>  6 (DSA-NSEC3-SHA1)
    #              :rsasha_1_nsec_3_sha_1      =>  7 (RSASHA1-NSEC3-SHA1)
    #              :rsa_sha_256                =>  8 (RSA/SHA-256)
    #              :rsa_sha_512                =>  10 (RSA/SHA-512)
    #              :ecc_gost                   =>  12 (ECC-GOST)
    #              :ecdsap_256_sha_256         =>  13 (ECDSAP256SHA256)
    #              :ecdsap_384_sha_384         =>  14 (ECDSAP384SHA384)
    # @param [Symbol] digest_type
    #                :sha_1           => 1 (SHA-1)
    #                :sha_256         => 2 (SHA-256)
    #                :gost_r_34_11_94 => 3 (GOST R 34.11-94)
    #                :sha_384         => 4 (SHA-384)
    # @param [String] digest
    def initialize(key_tag, alg, digest_type, digest)
      @alg = ALG[alg] || raise("Invalid alg #{alg}")
      @digest = digest
      if (0..65535).include?(key_tag)
        @key_tag = key_tag
      else
        raise "Invalid key tag #{key_tag}, should be 0<=key_tag<=65535"
      end
      @digest_type = DIGEST_TYPES[digest_type] || raise("Invalid digest type #{digest_type}")

      super("secDNS:dsData")
      self.add_element("secDNS:keyTag").text = @key_tag
      self.add_element("secDNS:alg").text = @alg
      self.add_element("secDNS:digestType").text = @digest_type
      self.add_element("secDNS:digest").text = @digest

    end

  end
end

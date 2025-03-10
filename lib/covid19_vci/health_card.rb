require 'health_cards'

module Covid19VCI
  module HealthCard
    def payload_from_jws(jws)
      return nil unless jws.present?

      raw_payload = jws.payload
      assert raw_payload&.length&.positive?, 'No payload found'

      decompressed_payload =
        begin
          Zlib::Inflate.new(-Zlib::MAX_WBITS).inflate(raw_payload)
        rescue Zlib::DataError
          assert false, 'Payload compression error. Unable to inflate payload.'
        end

      assert decompressed_payload.length.positive?, 'Payload compression error. Unable to inflate payload.'

      payload_length = decompressed_payload.length
      raw_payload_length = raw_payload.length
      decompressed_payload_length = decompressed_payload.length

      warning do
        assert raw_payload_length <= decompressed_payload_length,
              "Payload may not be properly minified. Received a payload with length #{raw_payload_length}, " \
              "but was able to generate a payload with length #{decompressed_payload_length}"
      end

      assert_valid_json decompressed_payload, 'Payload is not valid JSON'

      JSON.parse(decompressed_payload)
    end
  end
end